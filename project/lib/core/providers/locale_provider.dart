import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isUrdu => _locale.languageCode == 'ur';

  LocaleProvider() {
    _loadLocale();
  }

  void toggleLocale() {
    _locale = isUrdu ? const Locale('en') : const Locale('ur');
    _saveLocale();
    notifyListeners();
  }

  void setLocale(String langCode) {
    _locale = Locale(langCode);
    _saveLocale();
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('language') ?? 'en';
    _locale = Locale(lang);
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _locale.languageCode);
  }

  String t(Map<String, String> translations) {
    return translations[languageCode] ?? translations['en'] ?? '';
  }
}
