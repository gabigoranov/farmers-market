import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market/models/notification_preferences.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/message.dart' as message_entity;

/// A service for managing notifications, including both local notifications
/// and handling remote messages from Firebase Cloud Messaging (FCM).
class NotificationService {
  NotificationService._internal();

  /// Singleton instance of the CartService.
  static final NotificationService instance = NotificationService._internal();

  /// Factory constructor to access the singleton instance.
  factory NotificationService() {
    return instance;
  }

  // Flutter plugin for displaying local notifications.
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  late NotificationPreferences _preferences;

  NotificationPreferences get preferences => _preferences;

  /// Initializes the notification service.
  /// Sets up the Android-specific settings for local notifications.
  static Future<void> initialize() async {
    // Android-specific notification initialization settings.
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine all platform-specific initialization settings.
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

  }

  static void initializePreferences() {
    instance._preferences = UserService.instance.user.preferences;
  }

  Future<void> updatePreferences(NotificationPreferences preferences) async {
    _preferences = preferences;
    await UserService.instance.updateUserPreferences(preferences);
  }

  /// Displays a local notification with the given [title] and [body].
  static void showNotification(String title, String body) {
    // Android-specific notification details.
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id', // Unique channel ID.
      'channel_name', // Human-readable channel name.
      importance: Importance.max, // Maximum importance for high-priority notifications.
      priority: Priority.high, // High priority to show the notification immediately.
    );

    // Combine all platform-specific notification details.
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // Show the notification with a unique ID (here, `0` is used as the ID).
    _notificationsPlugin.show(
      0, // Notification ID.
      title, // Notification title.
      body, // Notification body.
      notificationDetails, // Notification details.
    );
  }

  /// Handles incoming Firebase messages and performs actions based on the message type.
  ///
  /// - If the message contains a notification, it displays it as a local notification.
  /// - If the message type is `orderUpdate`, it refreshes the user data and updates the order.
  /// - If the message type is `message`, it converts the data into a message entity
  ///   and adds it to the notification provider.
  static Future<void> handleMessage(RemoteMessage message) async {
    // If the notification part of the message is null, return early.
    if (message.notification?.title == null || message.notification?.body == null) return;

    // Display the notification as a local notification.
    showNotification(
      message.notification?.title ?? 'No Title', // Use "No Title" as fallback.
      message.notification?.body ?? 'No Body', // Use "No Body" as fallback.
    );

    // Handle custom data in the message payload.
    if (message.data["type"] == "orderUpdate") {
      // Refresh user data and update the order status.
      UserService.instance.refresh();
      NotificationProvider.instance.updateOrder(
        int.parse(message.data["id"]), // Parse the order ID as an integer.
        message.data["status"], // Extract the order status.
      );
    } else if (message.data["type"] == "message") {
      // Handle incoming chat messages.
      try {
        // Convert the message data into a message entity.
        message_entity.Message converted = message_entity.Message(
          senderId: message.data["senderId"] as String, // Sender ID.
          recipientId: message.data["recipientId"] as String, // Recipient ID.
          timestamp: DateTime.parse(message.data["timestamp"]), // Timestamp.
          content: message.notification?.body ?? "Error", // Message content.
        );

        // Add the message to the notification provider.
        await NotificationProvider.instance.addMessage(converted, true);
      } on Exception {
        // Log an error if message processing fails.
        print("Error");
      }
    }
  }
}
