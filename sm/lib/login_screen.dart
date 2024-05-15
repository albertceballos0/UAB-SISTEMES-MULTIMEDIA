import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/start_screen.dart';
import '../../providers/userProvider.dart';

class ScreenLogIn extends StatefulWidget {
  const ScreenLogIn({super.key});

  @override
  State<ScreenLogIn> createState() => _ScreenLogInState();
}

class _ScreenLogInState extends State<ScreenLogIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String _pass;
  late String _username;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 210,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Image.asset(
                '../assets/plant.png',
               )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                maxLength: 20,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  setState(() {
                    _username = value;
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
                    Provider.of<userProvider>(context, listen: false).logIn(_username, _pass).then((conn) {
                      if (!conn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => ScreenStart()),
                        );
                      }
                    });
                  },
                )),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (
                      context) => ScreenStart()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


