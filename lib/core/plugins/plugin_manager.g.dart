// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pluginManager)
final pluginManagerProvider = PluginManagerProvider._();

final class PluginManagerProvider extends $FunctionalProvider<
        AsyncValue<PluginManager>, PluginManager, FutureOr<PluginManager>>
    with $FutureModifier<PluginManager>, $FutureProvider<PluginManager> {
  PluginManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pluginManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pluginManagerHash();

  @$internal
  @override
  $FutureProviderElement<PluginManager> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PluginManager> create(Ref ref) {
    return pluginManager(ref);
  }
}

String _$pluginManagerHash() => r'a477ab376fab6737e4f9d28aa7d3de606f2e1252';
