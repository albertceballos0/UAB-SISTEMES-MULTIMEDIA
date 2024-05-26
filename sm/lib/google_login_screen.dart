import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:BOTANICAPP/start_screen.dart';
import '../../providers/userProvider.dart';

class ScreenGoogleLogIn extends StatefulWidget {
  const ScreenGoogleLogIn({super.key});

  @override
  State<ScreenGoogleLogIn> createState() => _ScreenGoogleLogInState();
}

class _ScreenGoogleLogInState extends State<ScreenGoogleLogIn> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body:  _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        height: 50,
        child: IconButton(
          icon: Image.asset('assets/google_logo.png'),
          onPressed:
          () async {
              bool conn = await Provider.of<userProvider>(context, listen: false).handleGoogleSignIn();
              if ( conn ) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScreenStart()),
                );
              }
            },
        ),
      ),
    );
  }
}