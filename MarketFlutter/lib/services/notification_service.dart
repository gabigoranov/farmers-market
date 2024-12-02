import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/user_service.dart';

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

  static void handleMessage(RemoteMessage message) {
    if(message.notification?.title == null || message.notification?.body == null) return;
    showNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
    );
    if(message.data["type"] == "orderUpdate"){
      UserService.instance.reload();
      print("YES");
      NotificationProvider.instance.updateOrder(int.parse(message.data["id"]), message.data["status"], );
    }
  }
}
