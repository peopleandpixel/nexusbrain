import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/data/services/webdav_sync_service.dart' show WebDavConfig;
import 'package:easy_localization/easy_localization.dart';
import 'package:nexusbrain/presentation/state/theme_state.dart';
import 'package:nexusbrain/presentation/state/locale_state.dart';
// webDavSyncProvider is imported from notes_state.dart

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _syncEnabled = false;
  String _syncStatus = '';

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('settings.title'.tr(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),

            _Section(title: 'settings.blockEditor'.tr(), children: [
              _SettingsTile(icon: Icons.format_list_bulleted_rounded, title: 'settings.blockBasedEditing'.tr(), subtitle: 'settings.blockBasedEditingSubtitle'.tr()),
              _SettingsTile(icon: Icons.link_rounded, title: 'settings.wikiLinks'.tr(), subtitle: 'settings.wikiLinksSubtitle'.tr()),
              _SettingsTile(icon: Icons.account_tree_rounded, title: 'settings.blockReferences'.tr(), subtitle: 'settings.blockReferencesSubtitle'.tr()),
            ]),
            const SizedBox(height: 16),

            _Section(title: 'settings.cloudSync'.tr(), children: [
              _SettingsTile(
                icon: Icons.cloud_outlined,
                title: 'settings.webDavSync'.tr(),
                subtitle: _syncStatus.isEmpty ? 'settings.webDavSyncSubtitle'.tr() : _syncStatus,
                trailing: Switch(
                  value: _syncEnabled,
                  onChanged: (v) => setState(() => _syncEnabled = v),
                  activeThumbColor: const Color(0xFF8B5CF6),
                ),
              ),
              if (_syncEnabled) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(children: [
                    TextField(controller: _urlController, decoration: InputDecoration(hintText: 'settings.webDavUrl'.tr(), labelText: 'settings.webDavUrlLabel'.tr(), isDense: true), style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(controller: _userController, decoration: InputDecoration(hintText: 'settings.username'.tr(), labelText: 'settings.username'.tr(), isDense: true), style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(controller: _passController, decoration: InputDecoration(hintText: 'settings.password'.tr(), labelText: 'settings.password'.tr(), isDense: true), obscureText: true, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _syncNow,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: Text('settings.syncNow'.tr()),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ]),
                ),
              ],
            ]),
            const SizedBox(height: 16),

            _Section(title: 'settings.wikiLinks'.tr(), children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('settings.wikiLinksExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.wikiLinksExampleDesc'.tr(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 12),
                  Text('settings.wikiLinksCustomExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.wikiLinksCustomExampleDesc'.tr(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 12),
                  Text('settings.blockRefExample'.tr(), style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('settings.blockRefExampleDesc'.tr(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ]),
              ),
            ]),
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
            ]),
            const SizedBox(height: 16),

            // Language selection
            _Section(title: 'settings.language'.tr(), children: [
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'settings.language'.tr(),
                subtitle: context.locale.languageCode == 'de' ? 'Deutsch' : 'English',
                trailing: DropdownButton<String>(
                  value: context.locale.languageCode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (lang) {
                    if (lang == 'de') {
                      context.setLocale(const Locale('de'));
                      ref.read(localeProvider.notifier).setLocale(const Locale('de'));
                    } else if (lang == 'en') {
                      context.setLocale(const Locale('en'));
                      ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    }
                  },
                ),
              ),
            ]),
            const SizedBox(height: 16),

            _Section(title: 'settings.about'.tr(), children: [
              _SettingsTile(icon: Icons.info_outlined, title: 'NexusBrain', subtitle: '${'settings.version'.tr()} — Block-Editor MVP'),
              _SettingsTile(icon: Icons.code_outlined, title: 'settings.techStack'.tr(), subtitle: 'settings.techStackSubtitle'.tr()),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _syncNow() async {
    if (_urlController.text.isEmpty || _userController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('common.enterCredentials'.tr())));
      return;
    }
    setState(() => _syncStatus = 'Synchronisiere...');
    try {
      final config = WebDavConfig(baseUrl: _urlController.text.replaceAll(RegExp(r'/+$'), ''), username: _userController.text, password: _passController.text);
      final service = ref.read(webDavSyncProvider(config));
      final result = await service.sync();
      if (result.success) {
        setState(() => _syncStatus = '✓ ${result.pushed} hochgeladen, ${result.pulled} heruntergeladen${result.conflicts > 0 ? ' (${result.conflicts} Konflikte)' : ''}');
        ref.invalidate(pagesProvider);
      } else {
        setState(() => _syncStatus = '✗ Fehler: ${result.error}');
      }
    } catch (e) {
      setState(() => _syncStatus = '✗ Fehler: $e');
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: const Color(0xFF8B5CF6), fontWeight: FontWeight.w600))),
      Container(decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2D2D44).withValues(alpha: 0.6))), child: Column(children: children)),
    ]);
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
    return ListTile(
      leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: const Color(0xFF8B5CF6), size: 20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      trailing: trailing ?? (_onTap != null ? const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)) : null),
      onTap: _onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
