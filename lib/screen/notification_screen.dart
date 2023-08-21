import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String id = '/notification_screen';

  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RemoteNotification?> notifications =
        ModalRoute.of(context)!.settings.arguments as List<RemoteNotification?>;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Notification'),
        ),
        body: notifications.isNotEmpty
            ? ListView.separated(  itemCount: notifications.length,
                itemBuilder: (context, index) {
                  if (notifications[index] != null) {
                    return ListTile(
                      title: Text(
                        '${notifications[index]!.title}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${notifications[index]!.body}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }

 return const SizedBox();
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
               )
            : const Center(
                child: Text(
                  'No Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ));
  }
}
