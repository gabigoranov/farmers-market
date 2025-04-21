import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../l10n/app_localizations.dart';
import '../models/notification_preferences.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  final NotificationPreferences initialPreferences;
  final Future<void> Function(NotificationPreferences) onSave;

  const NotificationPreferencesScreen({
    Key? key,
    required this.initialPreferences,
    required this.onSave,
  }) : super(key: key);

  @override
  _NotificationPreferencesScreenState createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  late NotificationPreferences _currentPreferences;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentPreferences = widget.initialPreferences;
  }

  void _handleToggle(String preferenceName, bool newValue) {
    setState(() {
      _hasChanges = true;
      switch (preferenceName) {
        case 'showNotifications':
          _currentPreferences.showNotifications = newValue;
          break;
        case 'showPurchaseUpdateNotifications':
          _currentPreferences.showPurchaseUpdateNotifications = newValue;
          break;
        case 'showSuggestionNotifications':
          _currentPreferences.showSuggestionNotifications = newValue;
          break;
        case 'showMessageNotifications':
          _currentPreferences.showMessageNotifications = newValue;
          break;
      }
    });
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      await widget.onSave(_currentPreferences);
      setState(() {
        _hasChanges = false;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveSuccess)),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveError)),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.unsavedChangesTitle),
        content: Text(AppLocalizations.of(context)!.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.discard),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (!didPop && _hasChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.notificationPreferences)),
          actions: [
            if (_hasChanges)
              TextButton(
                onPressed: _isSaving ? null : _handleSave,
                child: _isSaving
                    ? const CupertinoActivityIndicator()
                    : Text(AppLocalizations.of(context)!.save),
              ),
          ],
          elevation: 0.4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _NotificationPreferenceCard(
                title: AppLocalizations.of(context)!.enableNotifications,
                description: AppLocalizations.of(context)!.enableNotificationsDescription,
                value: _currentPreferences.showNotifications,
                onChanged: (value) => _handleToggle('showNotifications', value),
              ),
              const SizedBox(height: 8),
              _NotificationPreferenceCard(
                title: AppLocalizations.of(context)!.purchaseUpdates,
                description: AppLocalizations.of(context)!.purchaseUpdatesDescription,
                value: _currentPreferences.showPurchaseUpdateNotifications,
                onChanged: (value) => _handleToggle('showPurchaseUpdateNotifications', value),
              ),
              const SizedBox(height: 8),
              _NotificationPreferenceCard(
                title: AppLocalizations.of(context)!.productSuggestions,
                description: AppLocalizations.of(context)!.productSuggestionsDescription,
                value: _currentPreferences.showSuggestionNotifications,
                onChanged: (value) => _handleToggle('showSuggestionNotifications', value),
              ),
              const SizedBox(height: 8),
              _NotificationPreferenceCard(
                title: AppLocalizations.of(context)!.messages,
                description: AppLocalizations.of(context)!.messagesDescription,
                value: _currentPreferences.showMessageNotifications,
                onChanged: (value) => _handleToggle('showMessageNotifications', value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPreferenceCard extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationPreferenceCard({
    Key? key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.scale(
            scale: 0.9,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}