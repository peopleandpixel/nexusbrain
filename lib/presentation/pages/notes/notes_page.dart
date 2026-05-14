import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/theme.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/presentation/pages/notes/block_editor_page.dart';

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
                              ..shader = NexusBrainTheme.primaryGradient.createShader(
                                const Rect.fromLTWH(0, 0, 200, 40),
                              ),
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
                ]),
                const SizedBox(height: 16),
                _SearchBar(
                  onChanged: (value) => setState(() => _searchQuery = value),
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
        ]),
      ),
    );
  }

  Widget _buildPagesList(BuildContext context, List<domain.MdBombPage> pages) {
    final filtered = _searchQuery.isEmpty
        ? pages
        : pages.where((p) {
            final q = _searchQuery.toLowerCase();
            return p.title.toLowerCase().contains(q) ||
                p.tags.any((t) => t.toLowerCase().contains(q));
          }).toList();

    if (filtered.isEmpty) {
      return _EmptyState(hasPages: pages.isNotEmpty, onCreate: () => _createPage(context));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PageCard(
            page: filtered[index],
            onTap: () => _openPage(context, filtered[index]),
            onDelete: () => _deletePage(filtered[index].id),
          ),
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

  void _openPage(BuildContext context, domain.MdBombPage page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlockEditorPage(page: page)),
    );
  }

  void _deletePage(String id) async {
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
      await ref.read(pagesProvider.notifier).deletePage(id);
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
  final domain.MdBombPage page;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PageCard({required this.page, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: NexusBrainTheme.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D2D44).withValues(alpha: 0.6)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(page.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              Text(_formatDate(page.updatedAt), style: theme.textTheme.labelSmall),
              const SizedBox(width: 4),
              GestureDetector(onTap: onDelete, child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF64748B))),
            ]),
            if (page.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: page.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2))),
                child: Text(tag, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.w500)),
              )).toList()),
            ],
          ],
        ),
      ),
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
        width: 48, height: 48,
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
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D2D44)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
        decoration: InputDecoration(
          hintText: 'notes.searchPages'.tr(),
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
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
        Container(width: 80, height: 80, decoration: BoxDecoration(gradient: NexusBrainTheme.glowGradient, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.article_outlined, size: 40, color: Color(0xFF8B5CF6))),
        const SizedBox(height: 24),
        Text(hasPages ? 'notes.noResults'.tr() : 'notes.noPagesYet'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(hasPages ? 'notes.noResultsSubtitle'.tr() : 'notes.noPagesYetSubtitle'.tr(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B))),
        if (!hasPages) ...[
          const SizedBox(height: 24),
          GestureDetector(onTap: onCreate, child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), decoration: BoxDecoration(gradient: NexusBrainTheme.primaryGradient, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.add_rounded, color: Colors.white, size: 20), const SizedBox(width: 8), Text('notes.createFirstPage'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]))),
        ],
      ]),
    );
  }
}
