import 'dart:io';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/presentation/pages/notes/block_editor_page.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/theme.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pagesAsync = ref.watch(pagesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NexusBrain',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            foreground: Paint()
                              ..shader = NexusBrainTheme.primaryGradient
                                  .createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                        const SizedBox(height: 4),
                        pagesAsync.when(
                          data: (pages) => Text(
                            'notes.pagesCount'.tr(namedArgs: {'count': pages.length.toString()}),
                            style: theme.textTheme.bodySmall,
                          ).animate().fadeIn(delay: 200.ms),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  _GlowButton(
                    onTap: () => _createPage(context),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                  ).animate().scale(delay: 300.ms, duration: 300.ms),
                ],),
                const SizedBox(height: 16),
                _SearchBar(
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    ref.read(searchQueryProvider.notifier).update(value);
                  },
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              ],
            ),
          ),
          Expanded(
            child: pagesAsync.when(
              data: (pages) => _buildPagesList(context, pages),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('${'common.error'.tr()}: $error')),
            ),
          ),
        ],),
      ),
    );
  }

  Widget _buildPagesList(BuildContext context, List<domain.Page> pages) {
    if (_searchQuery.trim().isEmpty) {
      return _buildRegularList(context, pages);
    }
    return _buildSearchResultsList(context);
  }

  Widget _buildRegularList(BuildContext context, List<domain.Page> pages) {
    if (pages.isEmpty) {
      return _EmptyState(hasPages: false, onCreate: () => _createPage(context));
    }

    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 2 : 1,
        childAspectRatio: isDesktop ? 2.5 : 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return _PageCard(
          page: pages[index],
          onTap: () => _openPage(context, pages[index]),
          onDelete: () => _deletePage(pages[index].pageId),
        );
      },
    );
  }

  Widget _buildSearchResultsList(BuildContext context) {
    // We can use the searchResultsProvider from notes_state.dart
    // But since the current UI filters pages, we need to decide if we want to show blocks or pages.
    // The issue asks for FTS5 integration. Usually this implies searching block content.
    
    // For now, let's update the searchResultsProvider to use the new FTS search
    // and display the pages that contain the matching blocks.
    
    return Consumer(
      builder: (context, ref, _) {
        final searchResultsAsync = ref.watch(searchResultsProvider);
        
        return searchResultsAsync.when(
          data: (pages) {
            if (pages.isEmpty) {
              return Center(child: Text('notes.noResults'.tr()));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PageCard(
                    page: pages[index],
                    onTap: () => _openPage(context, pages[index]),
                    onDelete: () => _deletePage(pages[index].pageId),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        );
      },
    );
  }

  void _createPage(BuildContext context) async {
    final title = await _showCreatePageDialog(context);
    if (title != null && title.isNotEmpty) {
      await ref.read(pagesProvider.notifier).createPage(title);
    }
  }

  void _openPage(BuildContext context, domain.Page page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlockEditorPage(page: page)),
    );
  }

  void _deletePage(String pageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('notes.deletePage'.tr()),
        content: Text('notes.deletePageContent'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('common.cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('common.delete'.tr(), style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(pagesProvider.notifier).deletePage(pageId);
    }
  }

  Future<String?> _showCreatePageDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('notes.newPage'.tr()),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'notes.newPageTitle'.tr()),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('common.cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('notes.create'.tr()),
          ),
        ],
      ),
    );
  }
}

class _PageCard extends StatelessWidget {
  final domain.Page page;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PageCard({required this.page, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      onSecondaryTap: () async {
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {

          final window = await WindowController.create(
            const WindowConfiguration(
              hiddenAtLaunch: true,
              arguments: '',
            ),
          );
          await window.show();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.cardColor.withValues(alpha: 0.7),
                  theme.cardColor.withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(page.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                  ),
                  const SizedBox(width: 8),
                  Text(_formatDate(page.updatedAt ?? DateTime.now()), style: theme.textTheme.labelSmall),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.close_rounded, size: 16, color: theme.textTheme.bodySmall?.color),
                  ),
                ],),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${date.day}.${date.month}';
  }
}

class _GlowButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _GlowButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: NexusBrainTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'notes.searchPages'.tr(),
          hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: theme.textTheme.bodySmall?.color, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasPages;
  final VoidCallback onCreate;
  const _EmptyState({required this.hasPages, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(gradient: NexusBrainTheme.glowGradient, borderRadius: BorderRadius.circular(24)),
          child: const Icon(Icons.article_outlined, size: 40, color: Color(0xFF8B5CF6)),
        ),
        const SizedBox(height: 24),
        Text(hasPages ? 'notes.noResults'.tr() : 'notes.noPagesYet'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          hasPages ? 'notes.noResultsSubtitle'.tr() : 'notes.noPagesYetSubtitle'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
        if (!hasPages) ...[
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onCreate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: NexusBrainTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('notes.createFirstPage'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],),
            ),
          ),
        ],
      ],),
    );
  }
}
