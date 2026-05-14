import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/data/services/webdav_sync_service.dart' show WebDavConfig;
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
            Text('Einstellungen', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),

            _Section(title: 'Block-Editor', children: [
              _SettingsTile(icon: Icons.format_list_bulleted_rounded, title: 'Block-basiertes Editing', subtitle: 'Logseq-ähnlicher Outliner'),
              _SettingsTile(icon: Icons.link_rounded, title: 'WikiLinks', subtitle: '[[Seiten-Titel]] zum Verlinken'),
              _SettingsTile(icon: Icons.account_tree_rounded, title: 'Block-Referenzen', subtitle: '((block-id)) für tiefe Verlinkung'),
            ]),
            const SizedBox(height: 16),

            _Section(title: 'Cloud-Sync (WebDAV)', children: [
              _SettingsTile(
                icon: Icons.cloud_outlined,
                title: 'WebDAV-Sync',
                subtitle: _syncStatus.isEmpty ? 'Nextcloud / ownCloud' : _syncStatus,
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
                    TextField(controller: _urlController, decoration: const InputDecoration(hintText: 'https://cloud.example.com/remote.php/dav/files/user', labelText: 'WebDAV URL', isDense: true), style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(controller: _userController, decoration: const InputDecoration(hintText: 'Benutzername', labelText: 'Username', isDense: true), style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(controller: _passController, decoration: const InputDecoration(hintText: 'Passwort', labelText: 'Password', isDense: true), obscureText: true, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _syncNow,
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text('Jetzt synchronisieren'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ]),
                ),
              ],
            ]),
            const SizedBox(height: 16),

            _Section(title: 'WikiLinks', children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('[[Seiten Titel]]', style: TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Verweise auf andere Seiten erstellen', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 12),
                  const Text('[[Seiten Titel|Anzeigetext]]', style: TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Verweis mit benutzerdefiniertem Text', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 12),
                  const Text('((block-id))', style: TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Referenz auf einen bestimmten Block', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ]),
              ),
            ]),
            const SizedBox(height: 16),

            _Section(title: 'Über', children: [
              _SettingsTile(icon: Icons.info_outlined, title: 'NexusBrain', subtitle: 'Version 0.2.0 — Block-Editor MVP'),
              _SettingsTile(icon: Icons.code_outlined, title: 'Tech Stack', subtitle: 'Flutter + Drift + SQLite'),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _syncNow() async {
    if (_urlController.text.isEmpty || _userController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bitte WebDAV-Zugangsdaten eingeben')));
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
