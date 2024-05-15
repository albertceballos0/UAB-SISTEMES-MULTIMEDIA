import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm/start_screen.dart';
//import 'package:provider/provider.dart';

class ScreenHist extends StatefulWidget {
  const ScreenHist({super.key});

  @override
  State<ScreenHist> createState() => _ScreenHistState();
}

class _ScreenHistState extends State<ScreenHist> {
  late String user;
  bool selected = false;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    index == 0 ?
      Navigator.push(
        context,
        MaterialPageRoute(builder: (
            context) => const ScreenStart()),
      ) : null;
  }

  @override
  Widget build(BuildContext context) {
    //user = context.watch<userProvider>().user;
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
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: const [
              SizedBox(
                height: 100,
              ),
              Text("HISTORY"),
            ],
          ),
        )
    );
  }
}





