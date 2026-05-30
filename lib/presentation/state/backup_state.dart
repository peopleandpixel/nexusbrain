import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backup_state.g.dart';

enum BackupInterval { daily, weekly, monthly }

class BackupSettings {
  final bool enabled;
  final BackupInterval interval;
  final int keepCount;
  final DateTime? lastBackupTime;

  BackupSettings({
    this.enabled = false,
    this.interval = BackupInterval.daily,
    this.keepCount = 5,
    this.lastBackupTime,
  });

  BackupSettings copyWith({
    bool? enabled,
    BackupInterval? interval,
    int? keepCount,
    DateTime? lastBackupTime,
  }) {
    return BackupSettings(
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
      keepCount: keepCount ?? this.keepCount,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
    );
  }
}

@riverpod
class BackupSettingsNotifier extends _$BackupSettingsNotifier {
  @override
  BackupSettings build() {
    _load();
    return BackupSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastBackupTimeStr = prefs.getString('backup_last_time');
    state = BackupSettings(
      enabled: prefs.getBool('backup_enabled') ?? false,
      interval: BackupInterval.values[prefs.getInt('backup_interval') ?? 0],
      keepCount: prefs.getInt('backup_keep_count') ?? 5,
      lastBackupTime: lastBackupTimeStr != null ? DateTime.parse(lastBackupTimeStr) : null,
    );
  }

  Future<void> updateSettings({
    bool? enabled,
    BackupInterval? interval,
    int? keepCount,
    DateTime? lastBackupTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled != null) await prefs.setBool('backup_enabled', enabled);
    if (interval != null) await prefs.setInt('backup_interval', interval.index);
    if (keepCount != null) await prefs.setInt('backup_keep_count', keepCount);
    if (lastBackupTime != null) {
      await prefs.setString('backup_last_time', lastBackupTime.toIso8601String());
    }
    
    state = state.copyWith(
      enabled: enabled,
      interval: interval,
      keepCount: keepCount,
      lastBackupTime: lastBackupTime,
    );
  }
}
