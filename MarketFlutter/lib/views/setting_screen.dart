import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:market/services/locale_service.dart';
import 'package:market/views/notification_preferences_screen.dart';

import '../controllers/theme_controller.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';
import 'landing_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context)!.settingsTitle),
        ),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSettingsCard(
                context,
                icon: Icons.language,
                title: AppLocalizations.of(context)!.languageTitle,
                subtitle: AppLocalizations.of(context)!.languageSubtitle,
                onTap: () async => await _showLanguageDialog(context),
              ),
              const SizedBox(height: 10),
              _buildSettingsCard(
                context,
                icon: Icons.color_lens,
                title: AppLocalizations.of(context)!.themeTitle,
                subtitle: AppLocalizations.of(context)!.themeSubtitle,
                onTap: () => _showThemeDialog(context),
              ),
              const SizedBox(height: 10),
              _buildSettingsCard(
                context,
                icon: Icons.notifications,
                title: AppLocalizations.of(context)!.notificationsTitle,
                subtitle: AppLocalizations.of(context)!.notificationsSubtitle,
                onTap: () => {
                  Get.to(NotificationPreferencesScreen(initialPreferences: NotificationService.instance.preferences,
                    onSave: (newPreferences) async {
                      // Implement your save logic here
                      NotificationService.instance.updatePreferences(newPreferences);
                    },
                  ), transition: Transition.fade)
                },
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(
                context,
                icon: Icons.logout,
                title: AppLocalizations.of(context)!.logoutTitle,
                subtitle: AppLocalizations.of(context)!.logoutSubtitle,
                onTap: () => _confirmLogout(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: Theme.of(context).brightness == Brightness.light
                ? [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.14),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(1, 5),
              )
            ]
                : [],
            border: Theme.of(context).brightness == Brightness.dark
                ? Border.all(color: Colors.grey[700]!, width: 1)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDestructive
                            ? Colors.red
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    await LocaleService.instance.toggle();
  }

  void _showThemeDialog(BuildContext context) {
    ThemeController.to.toggleTheme();
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logoutTitle),
          content: Text(AppLocalizations.of(context)!.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                UserService.instance.logout();
                Get.offAll(const Landing(), transition: Transition.fade);
              },
              child: Text(
                AppLocalizations.of(context)!.logoutTitle,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

