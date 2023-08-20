import 'package:chat_app/screen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = '/register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
                duration: Duration(milliseconds: 150),
                child: Flexible(
                  child: Hero(
                      tag: 'logo',
                      child: SizedBox(
                          height: 150, child: Image.asset('images/logo.png'))),
                )),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              child: TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      email = value;
                    });
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              style: TextStyle(
                color: Colors.black,
              ),
              onChanged: (value) {
                if (value != null) {
                  password = value;
                }
              },
              decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: ()async {
                if(email!= null && password!= null){
                await  _auth.createUserWithEmailAndPassword(
                      email: email!, password: password!);
                  print('auth : $_auth');
                }
                Navigator.pushReplacementNamed(context, ChatScreen.id);

              },
              style: ElevatedButton.styleFrom(
                  elevation: 5, backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
