import 'package:chat_app/screen/auth/login_screen.dart';
import 'package:chat_app/screen/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _textEditingController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<RemoteNotification?> notifications = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  void getNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(message.notification);
        });
      }
    });
  }

  void getUser() {
    user = _auth.currentUser;
  }

  getStore() async {
    await for (var messages in _firestore.collection('messages').snapshots()) {
      for (var message in messages.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    getStore();
    getNotification();
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           NotificationScreen(notifications: notifications),
                //     ));
                Navigator.pushNamed(context, NotificationScreen.id,
                        arguments: notifications)
                    .then((value) {
                  setState(() {
                    notifications.clear();
                  });
                });
              },
              child: Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                  notifications.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 2),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text(
                            '${notifications.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              )),
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.id, (route) => false);
              },
              icon: const Icon(Icons.logout)),
        ],
        title: Row(
          children: [
            Image.asset(
              'images/logo.png',
              height: 40,
              width: 30,
            ),
            const Text('Chat'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: _firestore
                    .collection('messages')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var response = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: response.length,
                        itemBuilder: (context, index) {
                          return BubbleMessage(
                            sender: response[index].data()['sender'],
                            response: response[index].data()['text'],
                            isMe:
                                response[index].data()['sender'] == user!.email,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Not Data',
                        style: TextStyle(fontSize: 22),
                      ),
                    );
                  }
                },
              ),
              Container(
                decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.lightBlueAccent)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Typing your message here...',
                          // focusedBorder: OutlineInputBorder(
                          //     borderSide:
                          //         const BorderSide(width: 1, color: Colors.blue),
                          //     borderRadius: BorderRadius.circular(10)),
                          // disabledBorder: const UnderlineInputBorder(
                          //     borderSide: BorderSide.none)
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_textEditingController.text.isNotEmpty) {
                            _firestore
                                .collection('messages')
                                .add({
                                  'text': _textEditingController.text,
                                  'sender': user!.email,
                                  'time': DateTime.now(),
                                })
                                .then((value) => _textEditingController.clear())
                                .catchError((error) => print(error));
                          }
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleMessage extends StatelessWidget {
  const BubbleMessage({
    super.key,
    required this.response,
    required this.sender,
    required this.isMe,
  });

  final String response;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 5,
          ),
          Material(
              color: isMe ? Colors.lightBlueAccent : Colors.black54,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  response,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
