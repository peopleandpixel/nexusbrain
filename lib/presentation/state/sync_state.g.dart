// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncSettingsNotifier)
final syncSettingsProvider = SyncSettingsNotifierProvider._();

final class SyncSettingsNotifierProvider
    extends $NotifierProvider<SyncSettingsNotifier, SyncSettings> {
  SyncSettingsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncSettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncSettingsNotifierHash();

  @$internal
  @override
  SyncSettingsNotifier create() => SyncSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncSettings>(value),
    );
  }
}

String _$syncSettingsNotifierHash() =>
    r'996f3ce934d925ea4b08eb4d89b260397d99f7ee';

abstract class _$SyncSettingsNotifier extends $Notifier<SyncSettings> {
  SyncSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncSettings, SyncSettings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SyncSettings, SyncSettings>,
        SyncSettings,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
