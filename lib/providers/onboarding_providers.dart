import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';

class OnboardingNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'hasCompletedOnboarding';

  OnboardingNotifier(this._prefs) : super(_prefs.getBool(_key) ?? false);

  void completeOnboarding() {
    _prefs.setBool(_key, true);
    state = true;
  }
}

final onboardingCompletedProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});
