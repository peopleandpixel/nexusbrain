import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/core/plugins/plugin_manager.dart';
import 'package:nexusbrain/data/services/backup_service.dart';
import 'package:nexusbrain/data/services/mobile_service.dart';

import '../widgets/common/shortcut_overlay.dart';
import '../state/onboarding_state.dart';
import 'graph/graph_page.dart';
import 'notes/notes_page.dart';
import 'onboarding/onboarding_page.dart';
import 'settings/settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  late final _pages = <Widget>[
    const NotesPage(),
    const GraphPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackupService().checkAndRunAutomaticBackup(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // MobileService initialisieren (Sharing & Widgets)
    ref.watch(mobileServiceProvider);

    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final onboardingCompleted = ref.watch(onboardingStateProvider);

    if (!onboardingCompleted) {
      return const OnboardingPage();
    }

    if (isDesktop) {
      return Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                _buildSidebar(context),
                VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _pages[_currentIndex],
                  ),
                ),
              ],
            ),
            const ShortcutOverlay(),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[_currentIndex],
          ),
          const ShortcutOverlay(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.edit_note_rounded,
                  label: 'notes.title'.tr(),
                  isActive: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.account_tree_rounded,
                  label: 'graph.title'.tr(),
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'settings.title'.tr(),
                  isActive: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);
    final pluginManagerAsync = ref.watch(pluginManagerProvider);
    final sidebarExtensions = pluginManagerAsync.value?.getUiExtensions('sidebar') ?? [];

    return Container(
      width: 240,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'NexusBrain',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _SidebarItem(
            icon: Icons.edit_note_rounded,
            label: 'notes.title'.tr(),
            isActive: _currentIndex == 0,
            onTap: () => setState(() => _currentIndex = 0),
          ),
          _SidebarItem(
            icon: Icons.account_tree_rounded,
            label: 'graph.title'.tr(),
            isActive: _currentIndex == 1,
            onTap: () => setState(() => _currentIndex = 1),
          ),
          _SidebarItem(
            icon: Icons.settings_rounded,
            label: 'settings.title'.tr(),
            isActive: _currentIndex == 2,
            onTap: () => setState(() => _currentIndex = 2),
          ),

          if (sidebarExtensions.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Divider(),
            ),
            ...sidebarExtensions.map((ext) {
              return _SidebarItem(
                icon: _getIconData(ext['icon'] ?? 'extension'),
                label: ext['label'] ?? 'Plugin',
                isActive: false,
                onTap: () {
                  // Plugin actions could be handled here
                  if (ext['label'] == 'Plugin Guide') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Plugin Guide'),
                        content: const Text('Schau in docs/plugins.md für mehr Infos!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                  debugPrint('Plugin sidebar extension tapped: ${ext['label']}');
                },
              );
            }),
          ],

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${'settings.version'.tr()}: v1.0.0',
              style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'bolt': return Icons.bolt_rounded;
      case 'auto_awesome': return Icons.auto_awesome_rounded;
      case 'extension': return Icons.extension_rounded;
      case 'info': return Icons.info_outline_rounded;
      default: return Icons.extension_rounded;
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? theme.colorScheme.onSurface : theme.textTheme.bodySmall?.color,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
