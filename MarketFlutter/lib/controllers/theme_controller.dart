import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  final _selectedTheme = 'light'.obs; // Default theme
  String get selectedTheme => _selectedTheme.value;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedTheme.value = prefs.getString('theme') ?? 'light';
    _isDarkMode.value = _selectedTheme.value == 'dark';
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    _selectedTheme.value = _isDarkMode.value ? 'dark' : 'light';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', _selectedTheme.value);

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void setTheme(String theme) async {
    _selectedTheme.value = theme;
    _isDarkMode.value = theme == 'dark';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
