import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingCompleted extends _$OnboardingCompleted {
  static const String _key = 'kern_onboarding_completed';

  @override
  bool build() {
    _load();
    return false; // Default until loaded
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = true;
  }
}
