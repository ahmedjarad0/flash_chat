import 'package:chat_app/screen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;
  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getUser() {
    _auth.currentUser;
    print(_auth.currentUser);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {},
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
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  _auth
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) => Navigator.pushNamedAndRemoveUntil(
                          context, ChatScreen.id, (route) => false))
                      .catchError((error) => print(error));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter required Data')));
                }

              },
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text(
                'LogIn',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
