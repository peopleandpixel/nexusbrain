// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_font_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditorFont)
final editorFontProvider = EditorFontProvider._();

final class EditorFontProvider extends $NotifierProvider<EditorFont, String> {
  EditorFontProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'editorFontProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$editorFontHash();

  @$internal
  @override
  EditorFont create() => EditorFont();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$editorFontHash() => r'b36004eec59844e39a867df3e6cbb34110e8b4b2';

abstract class _$EditorFont extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
