import 'package:BOTANICAPP/hist_screen.dart';
import 'package:BOTANICAPP/login_screen.dart';
import 'package:BOTANICAPP/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/userProvider.dart';

class ScreenUser extends StatefulWidget {
  const ScreenUser({super.key});

  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {
  late User? _user;
  bool selected = false;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenStart()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenHist()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<userProvider>(context).user!;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            label: 'SEARCH',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.archivebox),
            label: 'HISTORIAL',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'USER',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body:  _userInfo(),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
              color: Colors.red,
              child: const Text("Sign Out"),
              onPressed: () async {
                await Provider.of<userProvider>(context, listen: false).signOut();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ScreenLogIn()),
                );
              }
          )
        ],
      ),
    );
  }
}