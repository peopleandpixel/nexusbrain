// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BiometricState)
final biometricStateProvider = BiometricStateProvider._();

final class BiometricStateProvider
    extends $NotifierProvider<BiometricState, bool> {
  BiometricStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'biometricStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$biometricStateHash();

  @$internal
  @override
  BiometricState create() => BiometricState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$biometricStateHash() => r'afe3c2097417606bad19aac138174971e5c35cb5';

abstract class _$BiometricState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
