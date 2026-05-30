import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sync_state.g.dart';

enum SyncType { webdav, git }

class SyncSettings {
  final bool enabled;
  final SyncType type;
  final String url;
  final String user;
  final String password;
  final String gitBranch;
  final bool e2eeEnabled;
  final String e2eePassword;
  final DateTime? lastSyncTime;

  SyncSettings({
    this.enabled = false,
    this.type = SyncType.webdav,
    this.url = '',
    this.user = '',
    this.password = '',
    this.gitBranch = 'main',
    this.e2eeEnabled = false,
    this.e2eePassword = '',
    this.lastSyncTime,
  });

  SyncSettings copyWith({
    bool? enabled,
    SyncType? type,
    String? url,
    String? user,
    String? password,
    String? gitBranch,
    bool? e2eeEnabled,
    String? e2eePassword,
    DateTime? lastSyncTime,
  }) {
    return SyncSettings(
      enabled: enabled ?? this.enabled,
      type: type ?? this.type,
      url: url ?? this.url,
      user: user ?? this.user,
      password: password ?? this.password,
      gitBranch: gitBranch ?? this.gitBranch,
      e2eeEnabled: e2eeEnabled ?? this.e2eeEnabled,
      e2eePassword: e2eePassword ?? this.e2eePassword,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

@riverpod
class SyncSettingsNotifier extends _$SyncSettingsNotifier {
  @override
  SyncSettings build() {
    _load();
    return SyncSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncTimeStr = prefs.getString('sync_last_sync_time');
    state = SyncSettings(
      enabled: prefs.getBool('sync_enabled') ?? false,
      type: SyncType.values[prefs.getInt('sync_type') ?? 0],
      url: prefs.getString('sync_url') ?? '',
      user: prefs.getString('sync_user') ?? '',
      password: prefs.getString('sync_password') ?? '',
      gitBranch: prefs.getString('sync_git_branch') ?? 'main',
      e2eeEnabled: prefs.getBool('sync_e2ee_enabled') ?? false,
      e2eePassword: prefs.getString('sync_e2ee_password') ?? '',
      lastSyncTime: lastSyncTimeStr != null ? DateTime.parse(lastSyncTimeStr) : null,
    );
  }

  Future<void> updateSettings({
    bool? enabled,
    SyncType? type,
    String? url,
    String? user,
    String? password,
    String? gitBranch,
    bool? e2eeEnabled,
    String? e2eePassword,
    DateTime? lastSyncTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled != null) await prefs.setBool('sync_enabled', enabled);
    if (type != null) await prefs.setInt('sync_type', type.index);
    if (url != null) await prefs.setString('sync_url', url);
    if (user != null) await prefs.setString('sync_user', user);
    if (password != null) await prefs.setString('sync_password', password);
    if (gitBranch != null) await prefs.setString('sync_git_branch', gitBranch);
    if (e2eeEnabled != null) await prefs.setBool('sync_e2ee_enabled', e2eeEnabled);
    if (e2eePassword != null) await prefs.setString('sync_e2ee_password', e2eePassword);
    if (lastSyncTime != null) await prefs.setString('sync_last_sync_time', lastSyncTime.toIso8601String());
    
    state = state.copyWith(
      enabled: enabled,
      type: type,
      url: url,
      user: user,
      password: password,
      gitBranch: gitBranch,
      e2eeEnabled: e2eeEnabled,
      e2eePassword: e2eePassword,
      lastSyncTime: lastSyncTime,
    );
  }
}
