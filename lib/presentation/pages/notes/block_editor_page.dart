import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/block.dart';

class BlockEditorPage extends ConsumerStatefulWidget {
  final domain.MdBombPage page;
  const BlockEditorPage({super.key, required this.page});

  @override
  ConsumerState<BlockEditorPage> createState() => _BlockEditorPageState();
}

class _BlockEditorPageState extends ConsumerState<BlockEditorPage> {
  late TextEditingController _titleController;
  final Map<String, TextEditingController> _blockControllers = {};
  final Map<String, FocusNode> _blockFocusNodes = {};
  final Map<String, _UndoState> _undoStack = {};
  final Map<String, _UndoState> _redoStack = {};
  String? _editingBlockId;

  bool _showLinkSuggestions = false;
  final List<domain.MdBombPage> _linkSuggestions = [];

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

  void _insertPageLink(domain.MdBombPage targetPage) {
    if (_editingBlockId == null) return;
    final controller = _blockControllers[_editingBlockId]!;
    final text = controller.text;
    final cursorPos = controller.selection.baseOffset;

    // Simple insert at cursor position
    final before = text.substring(0, cursorPos);
    final after = text.substring(cursorPos);
    final newText = '$before[[${targetPage.title}]]$after';

    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: before.length + targetPage.title.length + 4);
    setState(() => _showLinkSuggestions = false);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(currentPageBlocksProvider(widget.page.id));

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
              const SizedBox(width: 48),
            ]),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _titleController,
              style: theme.textTheme.headlineSmall,
              decoration: InputDecoration(hintText: 'notes.untitled'.tr(), hintStyle: const TextStyle(color: Color(0xFF64748B)), border: InputBorder.none, contentPadding: EdgeInsets.zero),
              onChanged: (value) => _debouncedSaveTitle(value),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2D2D44), height: 1),
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
        ]),
      ),
    );
  }

  Widget _buildBlockList(List<Block> blocks) {
    if (blocks.isEmpty) return _buildEmptyBlocks();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: blocks.length + 1,
      itemBuilder: (context, index) {
        if (index == blocks.length) return _buildAddBlockButton();
        return _BlockItem(
          key: ValueKey(blocks[index].id),
          block: blocks[index],
          controller: _getBlockController(blocks[index].id, blocks[index].content),
          focusNode: _blockFocusNodes[blocks[index].id] ?? FocusNode(),
          onEditingChanged: (blockId) => setState(() => _editingBlockId = blockId),
          onContentChanged: (blockId, content) => _debouncedSaveBlock(blockId, content),
          onIndent: () => _indentBlock(blocks[index].id),
          onOutdent: () => _outdentBlock(blocks[index].id),
          onDelete: () => _deleteBlock(blocks[index].id, blocks[index]),
          onAddChild: () => _addChildBlock(blocks[index].id),
          onAddAfter: () => _addBlockAfter(blocks[index].id),
          onUndo: () => _undo(blocks[index].id),
          onRedo: () => _redo(blocks[index].id),
          onClearRedoStack: () => _redoStack.remove(blocks[index].id),
          onSaveUndoState: () => _saveUndoState(blocks[index].id),
          onCycleTaskState: () => _cycleTaskState(blocks[index]),
        );
      },
    );
  }

  Widget _buildEmptyBlocks() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.format_list_bulleted_rounded, size: 48, color: Color(0xFF64748B)),
        const SizedBox(height: 16),
        Text('notes.emptyTitle'.tr(), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('notes.emptySubtitle'.tr(), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _addRootBlock,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text('notes.addBlock'.tr()),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ]),
    );
  }

  Widget _buildAddBlockButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: _addRootBlock,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFF1A1A2E).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2D2D44).withValues(alpha: 0.5))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.add_rounded, size: 18, color: Color(0xFF8B5CF6)), const SizedBox(width: 8), Text('notes.addBlock'.tr(), style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 13))]),
        ),
      ),
    );
  }

  Widget _buildLinkSuggestions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2D2D44)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (_linkSuggestions.isEmpty)
          Padding(padding: const EdgeInsets.all(16), child: Text('notes.noMatchingPages'.tr(), style: const TextStyle(color: Color(0xFF64748B)))),
        else
          ..._linkSuggestions.map((page) => ListTile(dense: true, leading: const Icon(Icons.article_outlined, size: 18, color: Color(0xFF8B5CF6)), title: Text(page.title, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14)), onTap: () => _insertPageLink(page))),
      ]),
    );
  }

  // ===================== ACTIONS =====================

  Timer? _titleDebounce;
  void _debouncedSaveTitle(String title) {
    _titleDebounce?.cancel();
    _titleDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _titleController.text == title) {
        ref.read(blockRepositoryProvider).updatePage(widget.page.copyWith(title: title));
      }
    });
  }

  final Map<String, Timer?> _blockDebounces = {};
  void _debouncedSaveBlock(String blockId, String content) {
    _blockDebounces[blockId]?.cancel();
    _blockDebounces[blockId] = Timer(const Duration(milliseconds: 300), () async {
      if (mounted && _blockControllers[blockId]?.text == content) {
        final existing = await ref.read(blockRepositoryProvider).getBlockById(blockId);
        if (existing != null) {
          ref.read(blockRepositoryProvider).updateBlock(existing.copyWith(content: content));
        }
      }
    });
  }

  void _addRootBlock() async {
    await ref.read(blockRepositoryProvider).createBlock(widget.page.id);
    ref.invalidate(currentPageBlocksProvider(widget.page.id));
  }

  void _addChildBlock(String parentId) async {
    final parent = await ref.read(blockRepositoryProvider).getBlockById(parentId);
    if (parent != null) {
      await ref.read(blockRepositoryProvider).createBlock(widget.page.id, parentId: parentId, indentLevel: parent.indentLevel + 1);
      ref.invalidate(currentPageBlocksProvider(widget.page.id));
    }
  }

  void _addBlockAfter(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockById(blockId);
    if (block != null) {
      await ref.read(blockRepositoryProvider).createBlock(widget.page.id, orderIndex: block.orderIndex + 1);
      ref.invalidate(currentPageBlocksProvider(widget.page.id));
    }
  }

  void _indentBlock(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockById(blockId);
    if (block != null && block.indentLevel < 5) {
      await ref.read(blockRepositoryProvider).updateBlock(block.copyWith(indentLevel: block.indentLevel + 1));
      ref.invalidate(currentPageBlocksProvider(widget.page.id));
    }
  }

  void _outdentBlock(String blockId) async {
    final block = await ref.read(blockRepositoryProvider).getBlockById(blockId);
    if (block != null && block.indentLevel > 0) {
      await ref.read(blockRepositoryProvider).updateBlock(block.copyWith(indentLevel: block.indentLevel - 1));
      ref.invalidate(currentPageBlocksProvider(widget.page.id));
    }
  }

  void _deleteBlock(String blockId, Block block) async {
    // Don't delete if it's the last block on the page
    final allBlocks = await ref.read(blockRepositoryProvider).getBlocksForPage(widget.page.id);
    if (allBlocks.length <= 1) {
      // Just clear the content instead
      await ref.read(blockRepositoryProvider).updateBlock(block.copyWith(content: ''));
      return;
    }

    await ref.read(blockRepositoryProvider).deleteBlock(blockId);
    _blockControllers[blockId]?.dispose();
    _blockFocusNodes[blockId]?.dispose();
    _blockControllers.remove(blockId);
    _blockFocusNodes.remove(blockId);
    _undoStack.remove(blockId);
    _redoStack.remove(blockId);
    ref.invalidate(currentPageBlocksProvider(widget.page.id));
  }

  void _cycleTaskState(Block block) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.cycleTaskState(block.id);
    ref.invalidate(currentPageBlocksProvider(widget.page.id));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final indentPadding = widget.block.indentLevel * 24.0;
    final hasFocus = widget.focusNode.hasFocus;

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
                        : (widget.block.indentLevel == 0 ? const Color(0xFF8B5CF6) : const Color(0xFF64748B)),
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
                    ? const Color(0xFF1A1A2E).withValues(alpha: 0.8)
                    : _isHovered
                        ? const Color(0xFF1A1A2E).withValues(alpha: 0.6)
                        : const Color(0xFF1A1A2E).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasFocus
                      ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
                      : const Color(0xFF2D2D44).withValues(alpha: 0.3),
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
                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, height: 1.5),
                    decoration: InputDecoration(
                      hintText: widget.block.content.isEmpty ? 'notes.typeHere'.tr() : null,
                      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    onTap: () => widget.onEditingChanged(widget.block.id),
                    onChanged: (value) => widget.onContentChanged(widget.block.id, value),
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
                  ]),
                ],
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final isCtrl = HardwareKeyboard.instance.isControlPressed;
    final isShift = HardwareKeyboard.instance.isShiftPressed;
    final isAlt = HardwareKeyboard.instance.isAltPressed;

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
    final repo = ref.read(taskRepositoryProvider);
    await repo.updateTaskState(widget.block.id, 'TODO');
    ref.invalidate(currentPageBlocksProvider(widget.block.pageId));
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
