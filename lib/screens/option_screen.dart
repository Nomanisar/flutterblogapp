import 'package:flutter/material.dart';
import 'package:myflutterblogapplication/components/rounded_buttons.dart';
import 'package:myflutterblogapplication/screens/loginscreen.dart';
import 'package:myflutterblogapplication/screens/signin.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/flutterflow1.png",
              height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButtons(
              title: "Login",
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButtons(
              title: "Register",
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Signin()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
