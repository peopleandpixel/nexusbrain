import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shortcut_state.g.dart';

@riverpod
class ShortcutOverlayState extends _$ShortcutOverlayState {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
