import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:BOTANICAPP/start_screen.dart';
import '../../providers/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';

class ScreenLogIn extends StatefulWidget {
  const ScreenLogIn({super.key});

  @override
  State<ScreenLogIn> createState() => _ScreenLogInState();
}

class _ScreenLogInState extends State<ScreenLogIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late String _pass;
  late String _email;
  bool _register = false;

  @override
  void initState() {
    super.initState();
    _pass = "";
    _email = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:
          _register ? Register() : LogIn()
      ),
    );
  }

  Widget LogIn(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 300,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Image(image: AssetImage('./assets/plant.png'))
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              textInputAction: TextInputAction.next,
              maxLength: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: 'Username',
              ),
              onChanged: (value) {
                setState(() {
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              maxLength: 20,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: 'Password',
              ),
              onChanged: (value) {
                setState(() {
                  _pass = value;
                });
              },
            ),
          ),
          Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Log In'),
                onPressed: () {

                },
              )),
          TextButton(
            onPressed: () {
              setState(() {
                _register = true;
              });
            },
            child: Text(
              'Register',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Container(
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
        ],
      ),
    );
  }

  Widget Register(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Image(image: AssetImage('./assets/plant.png'))
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              maxLength: 25,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: 'Email',
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              textInputAction: TextInputAction.next,
              maxLength: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: 'Username',
              ),
              onChanged: (value) {
                setState(() {
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              maxLength: 20,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.0),
                ),
                labelText: 'Password',
              ),
              onChanged: (value) {
                setState(() {
                  _pass = value;
                });
              },
            ),
          ),
          Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Register'),
                onPressed: () {}

              )),
          TextButton(
            onPressed: () {
              setState(() {
                _register = false;
              });
            },
            child: Text(
              'LogIn',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}


