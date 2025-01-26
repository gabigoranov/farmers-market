import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dio_service.dart';

// Initialize Dio client for making HTTP requests.
final dio = DioClient().dio;

// Secure storage instance for securely saving and reading data.
const storage = FlutterSecureStorage();

/// A service for managing the app's locale (language settings).
/// This service uses `Get.updateLocale` for switching the locale dynamically
/// and `FlutterSecureStorage` for persisting the selected locale.
final class LocaleService {
  // Factory constructor for accessing the singleton instance.
  factory LocaleService() {
    return instance;
  }

  // Private internal constructor to enforce singleton pattern.
  LocaleService._internal();

  // Singleton instance of the service.
  static final LocaleService instance = LocaleService._internal();

  // Current locale value, defaulting to English ("en").
  String _locale = "en";

  String get language => _locale;

  /// Initializes the service by reading the saved locale from secure storage
  /// and updating the app's locale accordingly.
  Future<void> init() async {
    // Read the stored locale from secure storage.
    String? read = await storage.read(key: "locale");
    if (read != null) {
      _locale = read; // Update the local `_locale` variable with the saved value.
    }

    // Update the app's locale with the saved or default value.
    await Get.updateLocale(Locale(_locale));
  }

  /// Toggles the app's locale between English ("en") and Bulgarian ("bg").
  Future<void> toggle() async {
    // Get the current app locale.
    final currentLocale = Get.locale?.languageCode;

    // Switch to Bulgarian if the current locale is English.
    if (currentLocale == 'en') {
      _locale = 'bg';
      await Get.updateLocale(Locale(_locale));
    }
    // Switch to English if the current locale is Bulgarian.
    else if (currentLocale == 'bg') {
      _locale = 'en';
      await Get.updateLocale(Locale(_locale));
    }

    // Save the updated locale to secure storage.
    await save();
  }

  /// Switches the app's language to a specified locale
  Future<void> setLocale(String locale) async {
    _locale = locale;
    await Get.updateLocale(Locale(_locale));

    // Save the updated locale to secure storage.
    await save();
  }

  /// Saves the current locale to secure storage.
  Future<void> save() async {
    await storage.write(key: 'locale', value: _locale);
  }
}
