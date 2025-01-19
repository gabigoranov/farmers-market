import 'package:flutter/material.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/user_service.dart';
import 'package:provider/provider.dart';
import '../models/dto/contact.dart';
import '../providers/notification_provider.dart';
import 'package:market/models/message.dart' as message_entity;

class ChatContactView extends StatefulWidget {
  final Contact contact;
  const ChatContactView({super.key, required this.contact});

  @override
  State<ChatContactView> createState() => _ChatContactViewState();
}

class _ChatContactViewState extends State<ChatContactView> {
  final TextEditingController _messageController = TextEditingController();
  List<message_entity.Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notificationProvider, Widget? child) {
        _messages = notificationProvider.messages[widget.contact.id] ?? [];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${widget.contact.firstName} ${widget.contact.lastName ?? ""}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[200], // Background color
                    child: ClipOval(
                      child: widget.contact.profilePictureURL != null
                          ? Image.network(
                        '${widget.contact.profilePictureURL}?w=60&h=60', // Load lower-resolution image
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Icon(Icons.person, size: 22); // Placeholder icon
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 22); // Fallback icon
                        },
                      )
                          : const Icon(Icons.person, size: 22), // Default icon if no URL
                    ),
                  ),
                ],
              ),
            ),
            shadowColor: Colors.black87,
            elevation: 0.4,
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];

                      return Align(
                        alignment: message.senderId == UserService.instance.user.id
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: message.senderId == UserService.instance.user.id ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                color: message.senderId == UserService.instance.user.id ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0), // Pill shape
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        String messageText = _messageController.text;
                        _messageController.clear();

                        if (messageText.isNotEmpty) {
                          setState(() {
                            var message = message_entity.Message(senderId: UserService.instance.user.id, recipientId: widget.contact.id, content: messageText, timestamp: DateTime.timestamp());
                            NotificationProvider.instance.addMessage(message, false);
                          });

                          FirebaseService.instance.sendMessage(
                            widget.contact.firebaseToken ?? "",
                            "${widget.contact.firstName} ${widget.contact.lastName ?? ""}",
                            messageText,
                            UserService.instance.user.id,
                            widget.contact.id,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
