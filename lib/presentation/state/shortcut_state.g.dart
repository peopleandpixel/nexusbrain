// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShortcutOverlayState)
final shortcutOverlayStateProvider = ShortcutOverlayStateProvider._();

final class ShortcutOverlayStateProvider
    extends $NotifierProvider<ShortcutOverlayState, bool> {
  ShortcutOverlayStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'shortcutOverlayStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shortcutOverlayStateHash();

  @$internal
  @override
  ShortcutOverlayState create() => ShortcutOverlayState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$shortcutOverlayStateHash() =>
    r'28a018fe7419986e609839c9a8de55658370425c';

abstract class _$ShortcutOverlayState extends $Notifier<bool> {
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
