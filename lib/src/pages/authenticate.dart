import 'package:flutter/material.dart';
import 'package:yoklama_sistemi/src/components/sign_in.dart';
import 'package:yoklama_sistemi/src/components/sign_up.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInPage(
        toggleView: toggleView,
      );
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}
