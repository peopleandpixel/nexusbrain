// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MobileService)
final mobileServiceProvider = MobileServiceProvider._();

final class MobileServiceProvider
    extends $NotifierProvider<MobileService, void> {
  MobileServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mobileServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mobileServiceHash();

  @$internal
  @override
  MobileService create() => MobileService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mobileServiceHash() => r'd432ece374bd365b8272ed83997fd5cde93b0af7';

abstract class _$MobileService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
