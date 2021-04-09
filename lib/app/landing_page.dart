import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/screens/temp_home_page.dart';
import 'package:login_screen/services/auth.dart';
import 'package:login_screen/services/database.dart';
import 'package:login_screen/sing_in/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            // child: EventsPage(),
            child: TempHomePage(),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
