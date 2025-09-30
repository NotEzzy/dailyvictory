import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  bool _isDarkMode;

  ThemeService(this._prefs) : _isDarkMode = _prefs.getBool(_themeKey) ?? false;

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _prefs.setBool(_themeKey, _isDarkMode);
      notifyListeners();
    }
  }

  // App Colors
  static const Color primaryColor = CupertinoColors.systemBlue;
  static const Color secondaryColor = CupertinoColors.systemIndigo;
  static const Color accentColor = CupertinoColors.systemTeal;
  
  // Light Theme Colors
  static const Color lightBackground = CupertinoColors.white;
  static const Color lightSurface = CupertinoColors.systemGrey6;
  static const Color lightText = CupertinoColors.black;
  static const Color lightSecondaryText = CupertinoColors.systemGrey;
  
  // Dark Theme Colors
  static const Color darkBackground = CupertinoColors.black;
  static const Color darkSurface = CupertinoColors.systemGrey6;
  static const Color darkText = CupertinoColors.white;
  static const Color darkSecondaryText = CupertinoColors.systemGrey2;

  // Get current theme colors
  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get surfaceColor => _isDarkMode ? darkSurface : lightSurface;
  Color get textColor => _isDarkMode ? darkText : lightText;
  Color get secondaryTextColor => _isDarkMode ? darkSecondaryText : lightSecondaryText;
} 