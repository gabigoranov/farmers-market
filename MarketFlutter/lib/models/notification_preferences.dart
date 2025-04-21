/// Represents a user's notification preferences and settings.
class NotificationPreferences {
  /// The unique identifier for the notification preferences record. ( uses the id of the related user )
  String userId;

  /// Whether notifications are globally enabled for the user.
  /// Default is `true`.
  bool showNotifications;

  /// Whether purchase update notifications are enabled.
  /// Default is `true`.
  bool showPurchaseUpdateNotifications;

  /// Whether product suggestion notifications are enabled.
  /// Default is `true`.
  bool showSuggestionNotifications;

  /// Whether message notifications are enabled.
  /// Default is `true`.
  bool showMessageNotifications;

  /// Creates a new NotificationPreferences instance.
  NotificationPreferences({
    this.showNotifications = true,
    this.showPurchaseUpdateNotifications = true,
    this.showSuggestionNotifications = true,
    this.showMessageNotifications = true,
    required this.userId,
  });

  /// Creates a NotificationPreferences instance from JSON data.
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      showNotifications: json['showNotifications'] ?? true,
      showPurchaseUpdateNotifications: json['showPurchaseUpdateNotifications'] ?? true,
      showSuggestionNotifications: json['showSuggestionNotifications'] ?? true,
      showMessageNotifications: json['showMessageNotifications'] ?? true,
      userId: json['userId'] as String,
    );
  }

  /// Converts this NotificationPreferences instance to JSON data.
  Map<String, dynamic> toJson() => {
    'showNotifications': showNotifications,
    'showPurchaseUpdateNotifications': showPurchaseUpdateNotifications,
    'showSuggestionNotifications': showSuggestionNotifications,
    'showMessageNotifications': showMessageNotifications,
    'userId': userId,
  };

}