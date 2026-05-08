import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'navigation_state.g.dart';

@riverpod
class NavigationState extends _$NavigationState {
  static const String _key = 'kern_nav_order';
  static const List<String> _defaultOrder = ['dashboard', 'data', 'settings'];

  @override
  List<String> build() {
    _loadFromPrefs();
    return _defaultOrder; // Return default while loading
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    if (saved != null && saved.isNotEmpty) {
      // Ensure 'settings' is always available
      if (!saved.contains('settings')) {
        saved.add('settings');
      }
      state = saved;
    } else {
      state = _defaultOrder;
    }
  }

  Future<void> updateOrder(List<String> newOrder) async {
    state = newOrder;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, newOrder);
  }
}
