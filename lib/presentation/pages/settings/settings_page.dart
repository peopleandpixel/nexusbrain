import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/core/sync/sync_manager.dart';
import 'package:nexusbrain/data/services/backup_service.dart';
import 'package:nexusbrain/presentation/pages/settings/plugin_marketplace_page.dart';
import 'package:nexusbrain/presentation/pages/settings/template_management_page.dart';
import 'package:nexusbrain/presentation/state/backup_state.dart';
import 'package:nexusbrain/presentation/state/biometric_state.dart';
import 'package:nexusbrain/presentation/state/editor_font_state.dart';
import 'package:nexusbrain/presentation/state/locale_state.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/state/onboarding_state.dart';
import 'package:nexusbrain/presentation/state/sync_state.dart';
import 'package:nexusbrain/presentation/state/theme_state.dart';
import 'package:nexusbrain/presentation/widgets/sync/sync_conflict_dialog.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _gitBranchController = TextEditingController();
  final _e2eePassController = TextEditingController();
  String _syncStatus = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(syncSettingsProvider);
      _urlController.text = settings.url;
      _userController.text = settings.user;
      _passController.text = settings.password;
      _gitBranchController.text = settings.gitBranch;
      _e2eePassController.text = settings.e2eePassword;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passController.dispose();
    _gitBranchController.dispose();
    _e2eePassController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final syncSettings = ref.watch(syncSettingsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('settings.title'.tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),

            _Section(title: 'settings.appearance'.tr(), children: [
              _SettingsTile(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Lock',
                subtitle: 'Require biometric authentication to open the app',
                trailing: Switch(
                  value: ref.watch(biometricStateProvider),
                  onChanged: (v) => ref.read(biometricStateProvider.notifier).setEnabled(v),
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.copy_all_rounded,
                title: 'Templates',
                subtitle: 'Vordefinierte Block-Strukturen verwalten',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const TemplateManagementPage()));
                },
              ),
              _SettingsTile(
                icon: Icons.font_download_rounded,
                title: 'settings.editorFont'.tr(),
                subtitle: 'settings.editorFontSubtitle'.tr(),
                trailing: DropdownButton<String>(
                  value: ref.watch(editorFontProvider),
                  items: ['Inter', 'Roboto Mono', 'JetBrains Mono', 'Open Sans'].map((f) => DropdownMenuItem(value: f, child: Text(f, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) {
                    if (v != null) ref.read(editorFontProvider.notifier).setFont(v);
                  },
                  underline: const SizedBox(),
                ),
              ),
              _SettingsTile(
                icon: Icons.extension_rounded,
                title: 'settings.pluginMarketplace'.tr(),
                subtitle: 'settings.pluginMarketplaceSubtitle'.tr(),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const PluginMarketplacePage()));
                },
              ),
            ],),
            const SizedBox(height: 16),

            _Section(title: 'settings.cloudSync'.tr(), children: [
              _SettingsTile(
                icon: Icons.sync_rounded,
                title: 'settings.cloudSync'.tr(),
                subtitle: _syncStatus.isEmpty ? 'settings.webDavSyncSubtitle'.tr() : _syncStatus,
                trailing: Switch(
                  value: syncSettings.enabled,
                  onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(enabled: v),
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (syncSettings.enabled) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('WebDAV'),
                            selected: syncSettings.type == SyncType.webdav,
                            onSelected: (v) {
                              if (v) ref.read(syncSettingsProvider.notifier).updateSettings(type: SyncType.webdav);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Git'),
                            selected: syncSettings.type == SyncType.git,
                            onSelected: (v) {
                              if (v) ref.read(syncSettingsProvider.notifier).updateSettings(type: SyncType.git);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController, 
                      onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(url: v),
                      decoration: InputDecoration(
                        hintText: syncSettings.type == SyncType.webdav ? 'settings.webDavUrl'.tr() : 'settings.gitUrl'.tr(), 
                        labelText: syncSettings.type == SyncType.webdav ? 'settings.webDavUrlLabel'.tr() : 'settings.gitUrlLabel'.tr(), 
                        isDense: true,
                      ), 
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (syncSettings.type == SyncType.git) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _gitBranchController, 
                        onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(gitBranch: v),
                        decoration: InputDecoration(hintText: 'main', labelText: 'settings.gitBranch'.tr(), isDense: true), 
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextField(
                      controller: _userController, 
                      onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(user: v),
                      decoration: InputDecoration(hintText: 'settings.username'.tr(), labelText: 'settings.username'.tr(), isDense: true), 
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passController, 
                      onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(password: v),
                      decoration: InputDecoration(hintText: 'settings.password'.tr(), labelText: 'settings.password'.tr(), isDense: true), 
                      obscureText: true, 
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'settings.e2eeEnabled'.tr(),
                      subtitle: 'End-to-End Verschlüsselung vor dem Upload',
                      trailing: Switch(
                        value: syncSettings.e2eeEnabled,
                        onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(e2eeEnabled: v),
                        activeThumbColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (syncSettings.e2eeEnabled) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _e2eePassController, 
                        onChanged: (v) => ref.read(syncSettingsProvider.notifier).updateSettings(e2eePassword: v),
                        decoration: InputDecoration(hintText: 'settings.e2eePassword'.tr(), labelText: 'settings.e2eePassword'.tr(), isDense: true), 
                        obscureText: true, 
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _syncNow,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: Text('settings.syncNow'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],),
                ),
              ],
            ],),
            const SizedBox(height: 16),

            _Section(title: 'settings.backupRestore'.tr(), children: [
              _SettingsTile(
                icon: Icons.history_rounded,
                title: 'settings.autoBackup'.tr(),
                subtitle: 'settings.autoBackupSubtitle'.tr(),
                trailing: Switch(
                  value: ref.watch(backupSettingsProvider).enabled,
                  onChanged: (v) => ref.read(backupSettingsProvider.notifier).updateSettings(enabled: v),
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (ref.watch(backupSettingsProvider).enabled) ...[
                _SettingsTile(
                  icon: Icons.timer_rounded,
                  title: 'settings.backupInterval'.tr(),
                  subtitle: '',
                  trailing: DropdownButton<BackupInterval>(
                    value: ref.watch(backupSettingsProvider).interval,
                    items: [
                      DropdownMenuItem(value: BackupInterval.daily, child: Text('settings.backupIntervalDaily'.tr())),
                      DropdownMenuItem(value: BackupInterval.weekly, child: Text('settings.backupIntervalWeekly'.tr())),
                      DropdownMenuItem(value: BackupInterval.monthly, child: Text('settings.backupIntervalMonthly'.tr())),
                    ],
                    onChanged: (v) {
                      if (v != null) ref.read(backupSettingsProvider.notifier).updateSettings(interval: v);
                    },
                    underline: const SizedBox(),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.numbers_rounded,
                  title: 'settings.keepCount'.tr(),
                  subtitle: 'settings.keepCountSubtitle'.tr(),
                  trailing: DropdownButton<int>(
                    value: ref.watch(backupSettingsProvider).keepCount,
                    items: [3, 5, 10, 20].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
                    onChanged: (v) {
                      if (v != null) ref.read(backupSettingsProvider.notifier).updateSettings(keepCount: v);
                    },
                    underline: const SizedBox(),
                  ),
                ),
              ],
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.upload_file_rounded,
                title: 'settings.exportBackup'.tr(),
                subtitle: 'settings.exportBackupSubtitle'.tr(),
                onTap: () async {
                  final path = await BackupService().exportBackup();
                  if (path != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('settings.backupSuccess'.tr(namedArgs: {'path': path}))),
                    );
                  }
                },
              ),
              _SettingsTile(
                icon: Icons.file_download_rounded,
                title: 'settings.importRestore'.tr(),
                subtitle: 'settings.importRestoreSubtitle'.tr(),
                onTap: () async {
                  final success = await BackupService().restoreBackup();
                  if (success && context.mounted) {
                    ref.invalidate(pagesProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('settings.restoreSuccess'.tr())),
                    );
                  }
                },
              ),
            ],),
            const SizedBox(height: 16),

            _Section(title: 'settings.wikiLinks'.tr(), children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('settings.wikiLinksExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.wikiLinksExampleDesc'.tr(), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                  const SizedBox(height: 12),
                  Text('settings.wikiLinksCustomExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.wikiLinksCustomExampleDesc'.tr(), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                  const SizedBox(height: 12),
                  Text('settings.blockRefExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.blockRefExampleDesc'.tr(), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                ],),
              ),
            ],),
            const SizedBox(height: 16),

            // Theme selection
            _Section(title: 'settings.theme'.tr(), children: [
              _SettingsTile(
                icon: Icons.brightness_6_rounded,
                title: 'settings.theme'.tr(),
                subtitle: 'settings.themeSystem'.tr(),
                trailing: DropdownButton<AppThemeMode>(
                  value: ref.watch(themeModeProvider),
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(value: AppThemeMode.light, child: Text('settings.themeLight'.tr())),
                    DropdownMenuItem(value: AppThemeMode.dark, child: Text('settings.themeDark'.tr())),
                    DropdownMenuItem(value: AppThemeMode.system, child: Text('settings.themeSystem'.tr())),
                  ],
                  onChanged: (mode) {
                    if (mode != null) ref.read(themeModeProvider.notifier).setTheme(mode);
                  },
                ),
              ),
            ],),
            const SizedBox(height: 16),

            // Language selection
            _Section(title: 'settings.language'.tr(), children: [
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'settings.language'.tr(),
                subtitle: _getLanguageName(context.locale.languageCode),
                trailing: DropdownButton<String>(
                  value: context.locale.languageCode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'it', child: Text('Italiano')),
                  ],
                  onChanged: (lang) {
                    if (lang != null) {
                      context.setLocale(Locale(lang));
                      ref.read(localeProvider.notifier).setLocale(Locale(lang));
                    }
                  },
                ),
              ),
            ],),
            const SizedBox(height: 16),

            _Section(title: 'settings.about'.tr(), children: [
              _SettingsTile(
                icon: Icons.tour_rounded,
                title: 'onboarding.showOnboarding'.tr(),
                subtitle: 'onboarding.showOnboardingSubtitle'.tr(),
                onTap: () {
                  ref.read(onboardingStateProvider.notifier).resetOnboarding();
                },
              ),
              _SettingsTile(icon: Icons.info_outlined, title: 'NexusBrain', subtitle: '${'settings.version'.tr()} — Block-Editor MVP'),
              _SettingsTile(icon: Icons.code_outlined, title: 'settings.techStack'.tr(), subtitle: 'settings.techStackSubtitle'.tr()),
            ],),
          ],
        ),
      ),
    );
  }

  Future<void> _syncNow() async {
    if (_urlController.text.isEmpty || _userController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('common.enterCredentials'.tr())),
      );
      return;
    }

    setState(() => _syncStatus = 'settings.syncing'.tr());

    try {
      final syncManager = ref.read(syncManagerProvider);
      final manager = SyncManager(
        repository: syncManager.repository,
        syncService: syncManager.syncService,
        isar: syncManager.isar,
        e2eeEnabled: syncManager.e2eeEnabled,
        e2eePassword: syncManager.e2eePassword,
        lastSyncTime: syncManager.lastSyncTime,
        onConflict: (conflict) async {
          return showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => SyncConflictDialog(conflict: conflict),
          );
        },
      );

      final newSyncTime = await manager.sync();
      
      if (newSyncTime != null) {
        await ref.read(syncSettingsProvider.notifier).updateSettings(lastSyncTime: newSyncTime);
      }

      if (mounted) {
        setState(() => _syncStatus = 'settings.syncSuccess'.tr());
        ref.invalidate(pagesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('settings.syncSuccess'.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _syncStatus = 'settings.syncError'.tr());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('settings.syncError'.tr(namedArgs: {'error': e.toString()})),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _getLanguageName(String code) {
    return switch (code) {
      'de' => 'Deutsch',
      'en' => 'English',
      'es' => 'Español',
      'fr' => 'Français',
      'it' => 'Italiano',
      _ => code,
    };
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8,), child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600))),
      Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.6))), child: Column(children: children)),
    ],);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({required this.icon, required this.title, required this.subtitle, this.trailing, VoidCallback? onTap}) : _onTap = onTap;
  final VoidCallback? _onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
      trailing: trailing ?? (_onTap != null ? Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodySmall?.color) : null),
      onTap: _onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
