import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  LocaleController() { _loadFromPrefs(); }

  void setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', locale.languageCode);
    notifyListeners();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('langCode') ?? 'ru';
    _locale = Locale(code);
    notifyListeners();
  }
}