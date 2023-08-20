import 'package:chat_app/screen/auth/login_screen.dart';
import 'package:chat_app/screen/auth/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSmall = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  curve: Curves.easeInBack,
                    duration: const Duration(milliseconds: 500),
                     height: isSmall?100:70,
                    decoration: isSmall ? BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15)
                    ):BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Hero(
                        tag: 'logo',
                        child: SizedBox(
                            height: 60,
                            child: Image.asset('images/logo.png')))),
                SizedBox(width: 10,),
                const Text(
                  textAlign: TextAlign.center,
                  'Flash Chat',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
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
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {

                  Navigator.pushNamed(context, RegisterScreen.id);

              },
              style: ElevatedButton.styleFrom(
                  elevation: 5,
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
