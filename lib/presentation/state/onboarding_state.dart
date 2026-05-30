import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.g.dart';

@riverpod
class OnboardingState extends _$OnboardingState {
  static const _key = 'onboarding_completed';

  @override
  bool build() {
    _load();
    return false; // Default to false so OnboardingPage is shown while loading
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }
}
