import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dio_service.dart';

final dio = DioClient().dio;
const storage = FlutterSecureStorage();

final class LocaleService {
  factory LocaleService() {
    return instance;
  }
  LocaleService._internal();
  static final LocaleService instance = LocaleService._internal();

  String _locale = "en";

  Future<void> init() async {
    String? read = await storage.read(key: "locale");
    if(read != null) {
      _locale = read;
    }

    await Get.updateLocale(Locale(_locale));
  }

  Future<void> toggle() async {
    final currentLocale = Get.locale?.languageCode;
    if (currentLocale == 'en') {
      _locale = 'bg';
      await Get.updateLocale(Locale(_locale));
    } else if (currentLocale == 'bg'){
      _locale = 'en';
      await Get.updateLocale(Locale(_locale));
    }

    await save();
  }

  Future<void> save() async{
    await storage.write(key: 'locale', value: _locale);
  }
}
