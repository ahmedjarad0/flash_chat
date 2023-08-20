import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<RemoteMessage> notifications;

  const NotificationScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Text('${notifications[index].notification!.title}');
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 12,);
          },
          itemCount: notifications.length),
    );
  }
}
