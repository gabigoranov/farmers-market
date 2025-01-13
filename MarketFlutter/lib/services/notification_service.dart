import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/message.dart' as message_entity;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    _notificationsPlugin.initialize(initializationSettings);
  }

  static void showNotification(String title, String body) {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    print(message.notification?.title);
    print(message.notification?.body);
    if(message.notification?.title == null || message.notification?.body == null) return;
    showNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
    );
    if(message.data["type"] == "orderUpdate"){
      UserService.instance.reload();
      NotificationProvider.instance.updateOrder(int.parse(message.data["id"]), message.data["status"], );
    } else if(message.data["type"] == "message") {
      try{
        message_entity.Message converted = message_entity.Message(
          senderId: message.data["senderId"] as String,
          recipientId: message.data["recipientId"] as String,
          timestamp: DateTime.parse(message.data["timestamp"]),
          content: message.notification?.body ?? "Error",
        );
        print(jsonEncode(converted));
        await NotificationProvider.instance.addMessage(converted, true);
      } on Exception {
        print("Error: message is not in the correct format.");
      }
    }

  }
}
