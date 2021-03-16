import 'package:flutter/material.dart';
import 'file:///D:/Study/Android%20Studio%20Projects/login_screen/lib/sing_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: EmailSignInForm(),
        ),
      ),
    );
  }
}
