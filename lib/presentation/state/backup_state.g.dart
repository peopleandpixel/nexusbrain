// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupSettingsNotifier)
final backupSettingsProvider = BackupSettingsNotifierProvider._();

final class BackupSettingsNotifierProvider
    extends $NotifierProvider<BackupSettingsNotifier, BackupSettings> {
  BackupSettingsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'backupSettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$backupSettingsNotifierHash();

  @$internal
  @override
  BackupSettingsNotifier create() => BackupSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupSettings>(value),
    );
  }
}

String _$backupSettingsNotifierHash() =>
    r'43068b020be588344c9919053cc329d8ca180d52';

abstract class _$BackupSettingsNotifier extends $Notifier<BackupSettings> {
  BackupSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BackupSettings, BackupSettings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BackupSettings, BackupSettings>,
        BackupSettings,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
