import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en', ''); // Default language

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void changeLocale(String languageCode) async {
    print("Changing locale");
    _locale = Locale(languageCode);
    await storage.write(key: 'locale', value: languageCode);
    print("Saved locale");
    notifyListeners();
    print("notified listeners");
  }

  _loadLocale() async {
    String? storedLocale = await storage.read(key: 'locale');
    print("read locale");
    if (storedLocale != null) {
      _locale = Locale(storedLocale, '');
    }
    notifyListeners();
    print("notified listeners");
  }
}