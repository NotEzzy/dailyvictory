import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailyvictory/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences before using this provider');
});

final themeServiceProvider = Provider<ThemeService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeService(prefs);
});

final themeModeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});

class ThemeNotifier extends StateNotifier<bool> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService) : super(_themeService.isDarkMode);

  Future<void> toggleTheme() async {
    await _themeService.toggleTheme();
    state = _themeService.isDarkMode;
  }

  Future<void> setTheme(bool isDark) async {
    await _themeService.setTheme(isDark);
    state = _themeService.isDarkMode;
  }
} 