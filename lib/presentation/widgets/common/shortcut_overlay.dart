import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/presentation/state/shortcut_state.dart';

class ShortcutOverlay extends ConsumerWidget {
  const ShortcutOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(shortcutOverlayStateProvider);
    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => ref.read(shortcutOverlayStateProvider.notifier).toggle(),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.keyboard_rounded, color: theme.colorScheme.primary),
                                const SizedBox(width: 12),
                                Text('notes.shortcuts.title'.tr(), style: theme.textTheme.titleLarge),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => ref.read(shortcutOverlayStateProvider.notifier).toggle(),
                                ),
                              ],
                            ),
                            Divider(height: 32, color: theme.dividerColor),
                            _ShortcutItem(keys: const ['?'], desc: 'notes.shortcuts.toggle'.tr()),
                            _ShortcutItem(keys: const ['Tab'], desc: 'notes.shortcuts.indent'.tr()),
                            _ShortcutItem(keys: const ['Shift', 'Tab'], desc: 'notes.shortcuts.outdent'.tr()),
                            _ShortcutItem(keys: const ['Ctrl', 'Enter'], desc: 'notes.shortcuts.createSubBlock'.tr()),
                            _ShortcutItem(keys: const ['Alt', 'Enter'], desc: 'notes.shortcuts.createBlockBelow'.tr()),
                            _ShortcutItem(keys: const ['[[', 'Title'], desc: 'notes.shortcuts.linkPage'.tr()),
                            _ShortcutItem(keys: const ['((', 'ID'], desc: 'notes.shortcuts.refBlock'.tr()),
                            _ShortcutItem(keys: const ['Ctrl', 'Z'], desc: 'notes.shortcuts.undo'.tr()),
                            _ShortcutItem(keys: const ['Ctrl', 'Backspace'], desc: 'notes.shortcuts.deleteBlock'.tr()),
                          ],
                        ),
                      ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final List<String> keys;
  final String desc;
  const _ShortcutItem({required this.keys, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ...keys.asMap().entries.map((e) => Row(children: [
                if (e.key > 0) const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('+', style: TextStyle(color: Color(0xFF64748B)))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D44),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF64748B).withValues(alpha: 0.3)),
                  ),
                  child: Text(e.value, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],),),
          const Spacer(),
          Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }
}
