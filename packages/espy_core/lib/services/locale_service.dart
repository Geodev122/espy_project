import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _key = 'user_locale';

  Locale get locale => _locale;

  LocaleService() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_key);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> toggleLocale() async {
    _locale = _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _locale.languageCode);
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
    notifyListeners();
  }
}
