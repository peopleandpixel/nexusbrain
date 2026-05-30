import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'editor_font_state.g.dart';

@riverpod
class EditorFont extends _$EditorFont {
  static const _key = 'editor_font';
  static const defaultFont = 'Inter';

  @override
  String build() {
    _load();
    return defaultFont;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key) ?? defaultFont;
    state = value;
  }

  Future<void> setFont(String font) async {
    state = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, font);
  }
}
