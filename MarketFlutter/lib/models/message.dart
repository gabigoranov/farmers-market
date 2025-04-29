import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  int? id;
  String senderId;
  String recipientId;
  String content;
  DateTime timestamp;

  Message({this.id, required this.senderId, required this.recipientId, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    Message res = Message(
      id: json['id'] as int?,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp']),
    );

    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp.toString(),
    };
  }

}