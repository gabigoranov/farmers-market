import 'package:flutter/material.dart';

import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundWhite,
  primaryColor: AppColors.primary,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.backgroundWhite,
    surfaceBright: AppColors.backgroundWhite,
    surfaceDim: AppColors.backgroundDark,
    error: AppColors.red,
    tertiary: AppColors.orange,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.softerDark),
    bodyMedium: TextStyle(color: AppColors.textDark),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundWhite,
    shadowColor: AppColors.backgroundDark,
    titleTextStyle: TextStyle(color: AppColors.backgroundDark.withValues(alpha: 0.87), fontSize: 20),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  primaryColor: AppColors.primary,
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.backgroundDark,
    surfaceDim: AppColors.backgroundWhite,
    error: AppColors.red,
    tertiary: AppColors.orange,
    surfaceBright: AppColors.backgroundDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textLight),
    bodyMedium: TextStyle(color: AppColors.textLight),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    shadowColor: AppColors.backgroundWhite,
    titleTextStyle: TextStyle(color: AppColors.backgroundWhite.withValues(alpha: 0.87), fontSize: 20, fontWeight: FontWeight.w600),
  ),
);