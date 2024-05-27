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
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            UserImageCard(imageUrl: _user!.photoURL!),
            SizedBox(height: 15,),
            UserInfoCard(icon: Icons.mail_outline, title: "MAIL", subtitle: _user!.email!),
            SizedBox(height: 15,),
            UserInfoCard(icon: Icons.account_box_outlined, title: "NAME", subtitle: _user!.displayName ?? ""),
            SizedBox(height: 120,),
            MaterialButton(
                color: Colors.redAccent,
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
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  UserInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
class UserImageCard extends StatelessWidget {
  final String imageUrl;

  UserImageCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(height: 16),
              Text(
                'Profile Picture',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
