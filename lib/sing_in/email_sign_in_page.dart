import 'package:flutter/material.dart';
import 'package:login_screen/sing_in/email_sign_in_form.dart';

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
