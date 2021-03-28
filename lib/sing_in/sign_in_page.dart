import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/components/rounded_button.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/sing_in/sign_in_bloc.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';
import 'package:login_screen/services/auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }
      ),
      //backgroundColor: animation.value,
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/1.jpg'),
                height: 170.0,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: TyperAnimatedTextKit(
                text: ['Your Events'],
                textStyle: TextStyle(
                  fontFamily: "Bobbers",
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            RoundedButton(
              title: 'Sign in with Google',
              colour: Colors.lightBlueAccent,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            RoundedButton(
              title: 'Sign in with email',
              colour: Colors.blueAccent,
              onPressed: isLoading ? null : () => _signInWithEmail(context),
            ),
            Text(
              'or',
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            RoundedButton(
              title: 'Go anonymous',
              colour: Colors.lightBlue[900],
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }

}
