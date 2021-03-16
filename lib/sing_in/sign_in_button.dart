import 'package:flutter/material.dart';
import 'file:///D:/Study/Android%20Studio%20Projects/login_screen/lib/components/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : assert(text != null),
        super(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 15.0),
        ),
        color: color,
        onPressed: onPressed,
      );
}