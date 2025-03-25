import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: ThemeController.to.toggleTheme,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: ThemeController.to.isDarkMode
            ? const Icon(Icons.dark_mode, key: ValueKey("dark"), size: 28, color: Colors.white)
            : const Icon(Icons.light_mode, key: ValueKey("light"), size: 28, color: Colors.amber),
      ),
    ));
  }
}
