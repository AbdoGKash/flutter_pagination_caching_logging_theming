// lib/storage/theme_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const _keyIsDark = 'is_dark_theme';

  final SharedPreferences _prefs;
  ThemeStorage(this._prefs);

  bool getIsDark() {
    return _prefs.getBool(_keyIsDark) ?? false;
  }

  Future<void> setIsDark(bool isDark) async {
    await _prefs.setBool(_keyIsDark, isDark);
  }

  // Optional helper to create instance
  static Future<ThemeStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeStorage(prefs);
  }
}
