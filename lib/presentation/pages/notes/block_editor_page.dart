import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexusbrain/core/plugins/plugin_manager.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/template.dart';
import 'package:nexusbrain/presentation/pages/notes/pdf_viewer_page.dart';
import 'package:nexusbrain/presentation/state/editor_font_state.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/state/shortcut_state.dart';
import 'package:share_plus/share_plus.dart';

class BlockEditorPage extends ConsumerStatefulWidget {
  final domain.Page page;
  const BlockEditorPage({super.key, required this.page});

  @override
  ConsumerState<BlockEditorPage> createState() => _BlockEditorPageState();
}

class _BlockEditorPageState extends ConsumerState<BlockEditorPage> {
  static _BlockEditorPageState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_BlockEditorPageState>();
  }

  late TextEditingController _titleController;
  final Map<String, TextEditingController> _blockControllers = {};
  final Map<String, FocusNode> _blockFocusNodes = {};
  final Map<String, _UndoState> _undoStack = {};
  final Map<String, _UndoState> _redoStack = {};
  String? _editingBlockId;

  bool _showLinkSuggestions = false;
  bool _showBlockSuggestions = false;
  bool _showTemplateSuggestions = false;
  int _suggestionIndex = 0;
  final List<domain.Page> _linkSuggestions = [];
  final List<Block> _blockSuggestions = [];
  final List<Template> _templateSuggestions = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _blockControllers.values) {
      c.dispose();
    }
    for (final f in _blockFocusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  TextEditingController _getBlockController(String blockId, String content) {
    if (!_blockControllers.containsKey(blockId)) {
      _blockControllers[blockId] = TextEditingController(text: content);
      _blockFocusNodes[blockId] = FocusNode();
    }
    return _blockControllers[blockId]!;
  }

  /// Inserts a wiki-link to the selected page into the current block.
  /// Replaces the triggering '[[' and any partial query with the full '[[Page Title]]'.
  void _insertPageLink(domain.Page targetPage) {
    if (_editingBlockId == null) return;
    final controller = _blockControllers[_editingBlockId]!;
    final text = controller.text;
    final cursorPos = controller.selection.baseOffset;

    // Find the [[ that triggered this
    final textBefore = text.substring(0, cursorPos);
    final linkStart = textBefore.lastIndexOf('[[');
    if (linkStart == -1) return;

    final before = text.substring(0, linkStart);
    final after = text.substring(cursorPos);
    final newText = '$before[[${targetPage.title}]]$after';

    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: before.length + targetPage.title.length + 4);
    setState(() {
      _showLinkSuggestions = false;
      _suggestionIndex = 0;
    });
  }

  /// Inserts a block reference into the current block.
  /// Replaces the triggering '((' and any partial query with the full '((block-id))'.
  void _insertBlockReference(Block targetBlock) {
    if (_editingBlockId == null) return;
    final controller = _blockControllers[_editingBlockId]!;
    final text = controller.text;
    final cursorPos = controller.selection.baseOffset;

    // Find the (( that triggered this
    final textBefore = text.substring(0, cursorPos);
    final refStart = textBefore.lastIndexOf('((');
    if (refStart == -1) return;

    final before = text.substring(0, refStart);
    final after = text.substring(cursorPos);
    final newText = '$before((${targetBlock.blockId}))$after';

    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: before.length + targetBlock.blockId.length + 4);
    setState(() {
      _showBlockSuggestions = false;
      _suggestionIndex = 0;
    });
  }

  void _insertTemplate(Template template) async {
    final blockId = _editingBlockId;
    if (blockId == null) return;

    final controller = _blockControllers[blockId];
    if (controller == null) return;

    final block = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
    if (block == null) return;

    // Find the /trigger that started this
    final text = controller.text;
    final cursorPos = controller.selection.baseOffset;
    final textBefore = text.substring(0, cursorPos);
    final triggerStart = textBefore.lastIndexOf('/');
    if (triggerStart == -1) return;

    final beforeTrigger = text.substring(0, triggerStart);
    final afterCursor = text.substring(cursorPos);

    // Process placeholders in template content
    String content = template.content;
    final now = DateTime.now();
    content = content.replaceAll('{{date}}', DateFormat('yyyy-MM-dd').format(now));
    content = content.replaceAll('{{time}}', DateFormat('HH:mm').format(now));
    content = content.replaceAll('{{datetime}}', DateFormat('yyyy-MM-dd HH:mm').format(now));

    final lines = content.split('\n');
    if (lines.isEmpty) return;

    // First line replaces the current block (the one with /template)
    // Keep text before the trigger
    final firstLine = beforeTrigger + lines[0] + afterCursor;
    block.content = firstLine;
    await ref.read(blockRepositoryProvider).updateBlock(block);
    controller.text = firstLine;

    // Additional lines create new blocks
    for (int i = 1; i < lines.length; i++) {
      await ref.read(blockRepositoryProvider).createBlock(
            widget.page.pageId,
            parentId: block.parentId,
            orderIndex: block.orderIndex + i,
            content: lines[i],
            indentLevel: block.indentLevel,
          );
    }

    setState(() {
      _showTemplateSuggestions = false;
      _suggestionIndex = 0;
    });

    // Refresh the block list to show new blocks
    ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
  }

  void _saveUndoState(String blockId) {
    final controller = _blockControllers[blockId];
    if (controller == null) return;
    _undoStack[blockId] = _UndoState(
      text: controller.text,
      cursorPos: controller.selection.baseOffset,
    );
  }

  void _undo(String blockId) {
    final state = _undoStack[blockId];
    if (state == null) return;
    final controller = _blockControllers[blockId];
    if (controller == null) return;
    // Save current state to redo stack before undoing
    _redoStack[blockId] = _UndoState(
      text: controller.text,
      cursorPos: controller.selection.baseOffset,
    );
    controller.text = state.text;
    controller.selection = TextSelection.collapsed(offset: state.cursorPos.clamp(0, controller.text.length));
  }

  void _redo(String blockId) {
    final state = _redoStack[blockId];
    if (state == null) return;
    final controller = _blockControllers[blockId];
    if (controller == null) return;
    // Save current state to undo stack before redoing
    _undoStack[blockId] = _UndoState(
      text: controller.text,
      cursorPos: controller.selection.baseOffset,
    );
    controller.text = state.text;
    controller.selection = TextSelection.collapsed(offset: state.cursorPos.clamp(0, controller.text.length));
  }

  void _sharePage() async {
    final blocks = await ref.read(currentPageBlocksProvider(widget.page.pageId).future);
    final buffer = StringBuffer();
    buffer.writeln(widget.page.title);
    buffer.writeln();

    for (var block in blocks) {
      final indent = '  ' * block.indentLevel;
      buffer.writeln('$indent- ${block.content}');
    }

    await SharePlus.instance.share(ShareParams(text: buffer.toString(), title: widget.page.title,));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(currentPageBlocksProvider(widget.page.pageId));
    final editorFont = ref.watch(editorFontProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // App bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
              const Spacer(),
              Text('notes.blockEditor'.tr(), style: theme.textTheme.titleSmall),
              const Spacer(),
              IconButton(onPressed: _sharePage, icon: const Icon(Icons.share_rounded)),
            ],),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _titleController,
              style: GoogleFonts.getFont(editorFont, textStyle: theme.textTheme.headlineSmall),
              decoration: InputDecoration(
                hintText: 'notes.untitled'.tr(),
                hintStyle: GoogleFonts.getFont(editorFont, color: theme.textTheme.bodySmall?.color),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _debouncedSaveTitle(value),
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: theme.dividerColor, height: 1),
          // Blocks
          Expanded(
            child: blocksAsync.when(
              data: (blocks) => _buildBlockList(blocks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text('notes.loadError'.tr())),
            ),
          ),
          if (_showLinkSuggestions && _linkSuggestions.isNotEmpty)
            _buildLinkSuggestions(),
          if (_showBlockSuggestions && _blockSuggestions.isNotEmpty)
            _buildBlockSuggestions(),
          if (_showTemplateSuggestions && _templateSuggestions.isNotEmpty)
            _buildTemplateSuggestions(),
        ],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(shortcutOverlayStateProvider.notifier).toggle(),
        mini: true,
        backgroundColor: theme.cardColor,
        child: Icon(Icons.keyboard_rounded, color: theme.colorScheme.primary),
      ),
    );
  }


  void _openPdf({int? page}) {
    if (widget.page.pdfPath == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(
          filePath: widget.page.pdfPath!,
          initialPage: page,
        ),
      ),
    );
  }

  Widget _buildBlockList(List<Block> blocks) {
    if (blocks.isEmpty) return _buildEmptyBlocks();

    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        if (oldIndex == newIndex || oldIndex >= blocks.length || newIndex >= blocks.length) return;
        
        // final block = blocks[oldIndex];
        // Note: Actual reordering in the DB would require updating 'position' fields.
        // For now, we provide the UI feedback.
      },
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: blocks.length + 1,
      itemBuilder: (context, index) {
        if (index == blocks.length) return _buildAddBlockButton(key: const ValueKey('add_block_btn'));
        return _BlockItem(
          key: ValueKey(blocks[index].blockId),
          block: blocks[index],
          controller: _getBlockController(blocks[index].blockId, blocks[index].content),
          focusNode: _blockFocusNodes[blocks[index].blockId] ?? FocusNode(),
          onEditingChanged: (blockId) => setState(() => _editingBlockId = blockId),
          onContentChanged: (blockId, content) => _debouncedSaveBlock(blockId, content),
          onIndent: () => _indentBlock(blocks[index].blockId),
          onOutdent: () => _outdentBlock(blocks[index].blockId),
          onDelete: () => _deleteBlock(blocks[index].blockId, blocks[index]),
          onAddChild: () => _addChildBlock(blocks[index].blockId),
          onAddAfter: () => _addBlockAfter(blocks[index].blockId),
          onUndo: () => _undo(blocks[index].blockId),
          onRedo: () => _redo(blocks[index].blockId),
          onClearRedoStack: () => _redoStack.remove(blocks[index].blockId),
          onSaveUndoState: () => _saveUndoState(blocks[index].blockId),
          onCycleTaskState: () => _cycleTaskState(blocks[index]),
          onPdfDeepLink: (page) => _openPdf(page: page),
          showSuggestions: (_showLinkSuggestions && _linkSuggestions.isNotEmpty) || (_showBlockSuggestions && _blockSuggestions.isNotEmpty) || (_showTemplateSuggestions && _templateSuggestions.isNotEmpty),
          suggestionIndex: _suggestionIndex,
          onSuggestionIndexChanged: (idx) => setState(() => _suggestionIndex = idx),
          onAcceptSuggestion: () {
            if (_showLinkSuggestions && _linkSuggestions.isNotEmpty) {
              _insertPageLink(_linkSuggestions[_suggestionIndex]);
            } else if (_showBlockSuggestions && _blockSuggestions.isNotEmpty) {
              _insertBlockReference(_blockSuggestions[_suggestionIndex]);
            } else if (_showTemplateSuggestions && _templateSuggestions.isNotEmpty) {
              _insertTemplate(_templateSuggestions[_suggestionIndex]);
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyBlocks() {
    final theme = Theme.of(context);
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.format_list_bulleted_rounded, size: 48, color: theme.textTheme.bodySmall?.color),
        const SizedBox(height: 16),
        Text('notes.emptyTitle'.tr(), style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('notes.emptySubtitle'.tr(), style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _addRootBlock,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text('notes.addBlock'.tr()),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],),
    );
  }

  Widget _buildAddBlockButton({Key? key}) {
    final theme = Theme.of(context);
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: _addRootBlock,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_rounded, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text('notes.addBlock'.tr(), style: TextStyle(color: theme.colorScheme.primary, fontSize: 13)),
          ],),
        ),
      ),
    );
  }

  Widget _buildLinkSuggestions() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_linkSuggestions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('notes.noMatchingPages'.tr(), style: TextStyle(color: theme.textTheme.bodySmall?.color)),
                ),
              if (_linkSuggestions.isNotEmpty)
                ..._linkSuggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final page = entry.value;
                  final isSelected = index == _suggestionIndex;
                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    leading: Icon(Icons.article_outlined, size: 18, color: theme.colorScheme.primary),
                    title: Text(page.title, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14)),
                    onTap: () => _insertPageLink(page),
                  );
                }),
            ],),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockSuggestions() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_blockSuggestions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('notes.noMatchingBlocks'.tr(), style: const TextStyle(color: Color(0xFF64748B))),
                ),
              if (_blockSuggestions.isNotEmpty)
                ..._blockSuggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final block = entry.value;
                  final isSelected = index == _suggestionIndex;
                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    leading: const Icon(Icons.reorder_rounded, size: 18, color: Color(0xFF8B5CF6)),
                    title: Text(
                      block.content.isEmpty ? 'notes.emptyBlock'.tr() : block.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
                    ),
                    onTap: () => _insertBlockReference(block),
                  );
                }),
            ],),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSuggestions() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.copy_all_rounded, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Templates',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _templateSuggestions.length,
                    itemBuilder: (context, index) {
                      final template = _templateSuggestions[index];
                      final isSelected = index == _suggestionIndex;
                      return Material(
                        color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            template.source == 'user' ? Icons.person_outline : Icons.extension_outlined,
                            size: 18,
                            color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                          ),
                          title: Text(
                            template.name,
                            style: TextStyle(
                              color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: template.description != null
                              ? Text(
                                  template.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color),
                                )
                              : null,
                          onTap: () => _insertTemplate(template),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== ACTIONS =====================

  Timer? _titleDebounce;
  void _debouncedSaveTitle(String title) {
    _titleDebounce?.cancel();
    _titleDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _titleController.text == title) {
        final updatedPage = widget.page;
        updatedPage.title = title;
        ref.read(blockRepositoryProvider).updatePage(updatedPage);
      }
    });
  }

  final Map<String, Timer?> _blockDebounces = {};
  void _debouncedSaveBlock(String blockId, String content) {
    // Handle link/block suggestions
    final controller = _blockControllers[blockId];
    if (controller != null) {
      final text = controller.text;
      final cursorPos = controller.selection.baseOffset;
      if (cursorPos > 0) {
        final textBefore = text.substring(0, cursorPos);
        
        // Page links [[
        if (textBefore.contains('[[')) {
          final lastOpen = textBefore.lastIndexOf('[[');
          final lastClose = textBefore.lastIndexOf(']]');
          if (lastOpen > lastClose) {
            final query = textBefore.substring(lastOpen + 2);
            _updateLinkSuggestions(query);
          } else {
            if (_showLinkSuggestions) {
              setState(() {
                _showLinkSuggestions = false;
                _suggestionIndex = 0;
              });
            }
          }
        } else {
          if (_showLinkSuggestions) {
            setState(() {
              _showLinkSuggestions = false;
              _suggestionIndex = 0;
            });
          }
        }

    // Templates /template
    if (textBefore.contains('/')) {
      final lastSlash = textBefore.lastIndexOf('/');
      // Check if it's potentially a command or template query
      final query = textBefore.substring(lastSlash + 1);
      if (query.startsWith('template') || _showTemplateSuggestions) {
        final templateQuery = query.startsWith('template') ? query.substring(8).trim() : query.trim();
        _updateTemplateSuggestions(templateQuery);
      } else {
        if (_showTemplateSuggestions) {
          setState(() {
            _showTemplateSuggestions = false;
            _suggestionIndex = 0;
          });
        }
      }
    } else if (_showTemplateSuggestions) {
      setState(() {
        _showTemplateSuggestions = false;
        _suggestionIndex = 0;
      });
    }

        // Block references ((
        if (textBefore.contains('((')) {
          final lastOpen = textBefore.lastIndexOf('((');
          final lastClose = textBefore.lastIndexOf('))');
          if (lastOpen > lastClose) {
            final query = textBefore.substring(lastOpen + 2);
            _updateBlockSuggestions(query);
          } else {
            if (_showBlockSuggestions) {
              setState(() {
                _showBlockSuggestions = false;
                _suggestionIndex = 0;
              });
            }
          }
        } else {
          if (_showBlockSuggestions) {
            setState(() {
              _showBlockSuggestions = false;
              _suggestionIndex = 0;
            });
          }
        }
      }
    }

    _blockDebounces[blockId]?.cancel();
    _blockDebounces[blockId] = Timer(const Duration(milliseconds: 300), () async {
      if (mounted && _blockControllers[blockId]?.text == content) {
        // Check for slash commands
        if (content.startsWith('/')) {
          final commandName = content.substring(1).split(' ').first;
          final pluginManagerAsync = ref.read(pluginManagerProvider);
          final pluginManager = pluginManagerAsync.value;
          if (pluginManager != null) {
            final commands = pluginManager.getSlashCommands();
            
            if (commands.contains(commandName)) {
              final existing = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
              if (existing != null) {
                final result = await pluginManager.executeSlashCommand(commandName, {
                  'blockId': blockId,
                  'content': content,
                  'pageId': existing.pageId,
                });
                
                if (result != null && result != 'undefined' && result != 'null') {
                  // If the command returned a string, replace content
                  _blockControllers[blockId]?.text = result.toString();
                  existing.content = result.toString();
                  await ref.read(blockRepositoryProvider).updateBlock(existing);
                  return; // Stop here if command was handled
                }
              }
            }
          }
        }

        final existing = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
        if (existing != null) {
          // Trigger onBlockUpdate hook
          final pluginManagerAsync = ref.read(pluginManagerProvider);
          final pluginManager = pluginManagerAsync.value;
          if (pluginManager != null) {
            final Map<String, dynamic> blockMap = {
              'blockId': existing.blockId,
              'content': content,
              'pageId': existing.pageId,
            };
            
            final result = await pluginManager.triggerHook('onBlockUpdate', blockMap);
            String finalContent = content;
            if (result is Map && result.containsKey('content')) {
              finalContent = result['content'];
              if (finalContent != content && mounted) {
                _blockControllers[blockId]?.text = finalContent;
              }
            }

            existing.content = finalContent;
            await ref.read(blockRepositoryProvider).updateBlock(existing);
          } else {
            // Fallback if plugin manager not ready
            existing.content = content;
            await ref.read(blockRepositoryProvider).updateBlock(existing);
          }
        }
      }
    });
  }

  /// Updates the list of suggested pages for wiki-links based on the [query].
  void _updateLinkSuggestions(String query) async {
    final results = await ref.read(blockRepositoryProvider).searchPages(query);
    if (mounted) {
      setState(() {
        _linkSuggestions.clear();
        _linkSuggestions.addAll(results);
        _showLinkSuggestions = true;
        _showBlockSuggestions = false; // Ensure mutually exclusive
        _showTemplateSuggestions = false;
        // Clamp index to new list size
        if (_suggestionIndex >= _linkSuggestions.length) {
          _suggestionIndex = (_linkSuggestions.length - 1).clamp(0, 999);
        }
      });
    }
  }

  /// Updates the list of suggested blocks for references based on the [query].
  void _updateBlockSuggestions(String query) async {
    final results = await ref.read(blockRepositoryProvider).searchBlocks(query);
    if (mounted) {
      setState(() {
        _blockSuggestions.clear();
        // Don't suggest the current editing block
        _blockSuggestions.addAll(results.where((b) => b.blockId != _editingBlockId).take(5));
        _showBlockSuggestions = true;
        _showLinkSuggestions = false; // Ensure mutually exclusive
        _showTemplateSuggestions = false;
        // Clamp index to new list size
        if (_suggestionIndex >= _blockSuggestions.length) {
          _suggestionIndex = (_blockSuggestions.length - 1).clamp(0, 999);
        }
      });
    }
  }

  void _updateTemplateSuggestions(String query) async {
    final userTemplates = await ref.read(blockRepositoryProvider).getAllTemplates();
    final pluginManagerAsync = ref.read(pluginManagerProvider);
    final pluginManager = pluginManagerAsync.value;
    
    final List<Template> allTemplates = [...userTemplates];
    
    if (pluginManager != null) {
      final pluginTemplatesData = pluginManager.getPluginTemplates();
      for (final data in pluginTemplatesData) {
        allTemplates.add(Template(
          templateId: data['templateId'] ?? 'plugin_${data['name']}',
          name: data['name'] ?? 'Plugin Template',
          content: data['content'] ?? '',
          description: data['description'],
          source: 'plugin',
        ),);
      }
    }

    final filtered = allTemplates.where((t) => t.name.toLowerCase().contains(query.toLowerCase())).toList();

    if (mounted) {
      setState(() {
        _templateSuggestions.clear();
        _templateSuggestions.addAll(filtered);
        _showTemplateSuggestions = true;
        _showLinkSuggestions = false;
        _showBlockSuggestions = false;
        if (_suggestionIndex >= _templateSuggestions.length) {
          _suggestionIndex = (_templateSuggestions.length - 1).clamp(0, 999);
        }
      });
    }
  }

  void _addRootBlock() async {
    final block = await ref.read(blockRepositoryProvider).createBlock(widget.page.pageId);
    
    // Trigger onBlockCreate hook
    final pluginManagerAsync = ref.read(pluginManagerProvider);
    final pluginManager = pluginManagerAsync.value;
    if (pluginManager != null) {
      await pluginManager.triggerHook('onBlockCreate', {
        'blockId': block.blockId,
        'content': block.content,
        'pageId': block.pageId,
      });
    }

    ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
  }

  void _addChildBlock(String parentId) async {
    final parent = await ref.read(blockRepositoryProvider).getBlockByBlockId(parentId);
    if (parent != null) {
      await ref.read(blockRepositoryProvider).createBlock(widget.page.pageId, parentId: parentId, indentLevel: parent.indentLevel + 1);
      ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
    }
  }

  void _addBlockAfter(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
    if (block != null) {
      await ref.read(blockRepositoryProvider).createBlock(widget.page.pageId, orderIndex: block.orderIndex + 1);
      ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
    }
  }

  void _indentBlock(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
    if (block != null && block.indentLevel < 5) {
      block.indentLevel = block.indentLevel + 1;
      await ref.read(blockRepositoryProvider).updateBlock(block);
      ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
    }
  }

  void _outdentBlock(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockByBlockId(blockId);
    if (block != null && block.indentLevel > 0) {
      block.indentLevel = block.indentLevel - 1;
      await ref.read(blockRepositoryProvider).updateBlock(block);
      ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
    }
  }

  void _deleteBlock(String blockId, Block block) async {
    // Don't delete if it's the last block on the page
    final allBlocks = await ref.read(blockRepositoryProvider).getBlocksForPage(widget.page.pageId);
    if (allBlocks.length <= 1) {
      // Just clear the content instead
      block.content = '';
      await ref.read(blockRepositoryProvider).updateBlock(block);
      return;
    }

    await ref.read(blockRepositoryProvider).deleteBlock(blockId);
    _blockControllers[blockId]?.dispose();
    _blockFocusNodes[blockId]?.dispose();
    _blockControllers.remove(blockId);
    _blockFocusNodes.remove(blockId);
    _undoStack.remove(blockId);
    _redoStack.remove(blockId);
    ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
  }

  void _cycleTaskState(Block block) async {
    final blockToUpdate = await ref.read(blockRepositoryProvider).getBlockByBlockId(block.blockId);
    if (blockToUpdate == null) return;
    
    final states = [null, 'TODO', 'DOING', 'DONE', 'CANCELLED'];
    final currentIndex = states.indexOf(blockToUpdate.taskState);
    final nextIndex = (currentIndex + 1) % states.length;
    blockToUpdate.taskState = states[nextIndex];
    
    await ref.read(blockRepositoryProvider).updateBlock(blockToUpdate);
    ref.invalidate(currentPageBlocksProvider(widget.page.pageId));
  }
}

class _UndoState {
  final String text;
  final int cursorPos;
  _UndoState({required this.text, required this.cursorPos});
}

// ===================== BLOCK ITEM WIDGET =====================

class _BlockItem extends ConsumerStatefulWidget {
  final Block block;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onEditingChanged;
  final void Function(String blockId, String content) onContentChanged;
  final VoidCallback onIndent;
  final VoidCallback onOutdent;
  final VoidCallback onDelete;
  final VoidCallback onAddChild;
  final VoidCallback onAddAfter;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClearRedoStack;
  final VoidCallback onSaveUndoState;
  final VoidCallback onCycleTaskState;
  final Function(int)? onPdfDeepLink;
  final bool showSuggestions;
  final int suggestionIndex;
  final ValueChanged<int> onSuggestionIndexChanged;
  final VoidCallback onAcceptSuggestion;

  const _BlockItem({
    super.key,
    required this.block,
    required this.controller,
    required this.focusNode,
    required this.onEditingChanged,
    required this.onContentChanged,
    required this.onIndent,
    required this.onOutdent,
    required this.onDelete,
    required this.onAddChild,
    required this.onAddAfter,
    required this.onUndo,
    required this.onRedo,
    required this.onClearRedoStack,
    required this.onSaveUndoState,
    required this.onCycleTaskState,
    this.onPdfDeepLink,
    required this.showSuggestions,
    required this.suggestionIndex,
    required this.onSuggestionIndexChanged,
    required this.onAcceptSuggestion,
  });

  @override
  ConsumerState<_BlockItem> createState() => _BlockItemState();
}

class _BlockItemState extends ConsumerState<_BlockItem> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onContentChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onContentChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Rebuild to show/hide action bar
  }

  void _onContentChange() {
    // Save undo state on first change after focus
    if (widget.focusNode.hasFocus) {
      widget.onSaveUndoState();
      // Clear redo stack on new input
      widget.onClearRedoStack();

      // Check for PDF deep links - only if newly typed/pasted
      final text = widget.controller.text;
      final pdfRegex = RegExp(r'pdf://page=(\d+)');
      final match = pdfRegex.firstMatch(text);
      if (match != null) {
        final cursorPos = widget.controller.selection.baseOffset;
        final matchEnd = match.end;
        // If cursor is right after the link, trigger it (likely just finished typing or clicked)
        if (cursorPos == matchEnd) {
          final page = int.tryParse(match.group(1) ?? '');
          if (page != null) {
            widget.onPdfDeepLink?.call(page);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indentPadding = widget.block.indentLevel * 24.0;
    final hasFocus = widget.focusNode.hasFocus;
    final editorFont = ref.watch(editorFontProvider);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: EdgeInsets.only(left: indentPadding, bottom: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Bullet / drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 8),
            child: GestureDetector(
              onTap: () {
                // Toggle task state on bullet tap
                if (widget.block.isTask) {
                  widget.onCycleTaskState();
                } else {
                  // Convert to TODO
                  _convertToTask();
                }
              },
              child: Container(
                width: 20, height: 20,
                alignment: Alignment.center,
                child: Text(
                  widget.block.taskIcon.isNotEmpty ? widget.block.taskIcon : '•',
                  style: TextStyle(
                    color: widget.block.taskIcon.isNotEmpty
                        ? Color(widget.block.taskColor)
                        : (widget.block.indentLevel == 0 ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color),
                    fontSize: widget.block.taskIcon.isNotEmpty ? 14 : 18,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: hasFocus
                    ? theme.cardColor.withValues(alpha: 0.8)
                    : _isHovered
                        ? theme.cardColor.withValues(alpha: 0.6)
                        : theme.cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasFocus
                      ? theme.colorScheme.primary.withValues(alpha: 0.5)
                      : theme.dividerColor.withValues(alpha: 0.3),
                  width: hasFocus ? 1.5 : 1,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Task state indicator
                if (widget.block.isTask) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(widget.block.taskColor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Color(widget.block.taskColor).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.block.taskState!,
                      style: TextStyle(color: Color(widget.block.taskColor), fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                // Text field with keyboard shortcuts
                KeyboardListener(
                  focusNode: FocusNode(skipTraversal: true),
                  onKeyEvent: _handleKeyEvent,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    style: GoogleFonts.getFont(
                      editorFont,
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.block.content.isEmpty ? 'notes.typeHere'.tr() : null,
                      hintStyle: GoogleFonts.getFont(
                        editorFont,
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    onTap: () {
                      widget.onEditingChanged(widget.block.blockId);
                      // Refresh suggestions on tap
                      widget.onContentChanged(widget.block.blockId, widget.controller.text);
                    },
                    onChanged: (value) => widget.onContentChanged(widget.block.blockId, value),
                  ),
                ),
                // Action bar (visible on focus or hover)
                if (hasFocus || _isHovered) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    _BlockAction(icon: Icons.format_indent_increase_rounded, tooltip: 'Einrücken (Tab)', onTap: widget.onIndent),
                    const SizedBox(width: 4),
                    _BlockAction(icon: Icons.format_indent_decrease_rounded, tooltip: 'Ausrücken (Shift+Tab)', onTap: widget.onOutdent),
                    const SizedBox(width: 4),
                    _BlockAction(icon: Icons.add_rounded, tooltip: 'Unterblock (Ctrl+Enter)', onTap: widget.onAddChild),
                    const SizedBox(width: 4),
                    _BlockAction(icon: Icons.keyboard_return, tooltip: 'Block darunter (Alt+Enter)', onTap: widget.onAddAfter),
                    const SizedBox(width: 4),
                    _BlockAction(icon: Icons.undo_rounded, tooltip: 'Rückgängig (Ctrl+Z)', onTap: widget.onUndo),
                    const SizedBox(width: 4),
                    _BlockAction(icon: Icons.redo_rounded, tooltip: 'Wiederherstellen (Ctrl+Shift+Z)', onTap: widget.onRedo),
                    const Spacer(),
                    if (widget.block.isTask)
                      _BlockAction(icon: Icons.check_circle_outline, tooltip: 'Status wechseln', onTap: widget.onCycleTaskState, color: Color(widget.block.taskColor)),
                    _BlockAction(icon: Icons.delete_outline_rounded, tooltip: 'Löschen (Ctrl+Backspace)', onTap: widget.onDelete, color: const Color(0xFFEF4444)),
                  ],),
                ],
              ],),
            ),
          ),
        ],),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final isCtrl = HardwareKeyboard.instance.isControlPressed;
    final isShift = HardwareKeyboard.instance.isShiftPressed;
    final isAlt = HardwareKeyboard.instance.isAltPressed;

    // Suggestion navigation
    if (widget.showSuggestions) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        int maxIndex = 0;
        if (_BlockEditorPageState._of(context)?._showLinkSuggestions ?? false) {
          maxIndex = (_BlockEditorPageState._of(context)?._linkSuggestions.length ?? 0) - 1;
        } else if (_BlockEditorPageState._of(context)?._showBlockSuggestions ?? false) {
          maxIndex = (_BlockEditorPageState._of(context)?._blockSuggestions.length ?? 0) - 1;
        } else if (_BlockEditorPageState._of(context)?._showTemplateSuggestions ?? false) {
          maxIndex = (_BlockEditorPageState._of(context)?._templateSuggestions.length ?? 0) - 1;
        }

        if (maxIndex >= 0) {
          final newIdx = (widget.suggestionIndex + 1).clamp(0, maxIndex);
          widget.onSuggestionIndexChanged(newIdx);
          return;
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        final newIdx = (widget.suggestionIndex - 1).clamp(0, 999);
        widget.onSuggestionIndexChanged(newIdx);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.tab) {
        widget.onAcceptSuggestion();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onContentChanged(widget.block.blockId, widget.controller.text); // This will refresh and potentially hide
        return;
      }
    }

    // Enter = add child block
    if (event.logicalKey == LogicalKeyboardKey.enter && !isCtrl && !isShift && !isAlt) {
      // Let the default behavior handle it (newline in TextField)
      // But if the block is empty, add a new sibling instead
      if (widget.controller.text.isEmpty) {
        widget.onAddAfter();
      }
      return;
    }

    // Ctrl+Enter = add child block
    if (event.logicalKey == LogicalKeyboardKey.enter && isCtrl) {
      widget.onAddChild();
      return;
    }

    // Alt+Enter = add block after
    if (event.logicalKey == LogicalKeyboardKey.enter && isAlt) {
      widget.onAddAfter();
      return;
    }

    // Tab = indent
    if (event.logicalKey == LogicalKeyboardKey.tab && !isShift) {
      widget.onIndent();
      return;
    }

    // Shift+Tab = outdent
    if (event.logicalKey == LogicalKeyboardKey.tab && isShift) {
      widget.onOutdent();
      return;
    }

    // Ctrl+Z = undo
    if (event.logicalKey == LogicalKeyboardKey.keyZ && isCtrl && !isShift) {
      widget.onUndo();
      return;
    }

    // Ctrl+Shift+Z = redo
    if (event.logicalKey == LogicalKeyboardKey.keyZ && isCtrl && isShift) {
      widget.onRedo();
      return;
    }

    // Ctrl+Backspace = delete block
    if (event.logicalKey == LogicalKeyboardKey.backspace && isCtrl) {
      widget.onDelete();
      return;
    }

    // Ctrl+T = toggle task state
    if (event.logicalKey == LogicalKeyboardKey.keyT && isCtrl) {
      widget.onCycleTaskState();
      return;
    }
  }

  void _convertToTask() async {
    widget.onCycleTaskState(); // This is already passed from the parent and has access to providers
  }
}

class _BlockAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;

  const _BlockAction({required this.icon, required this.onTap, this.color, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D44).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: color ?? const Color(0xFF64748B)),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: widget);
    }
    return widget;
  }
}

