import 'dart:io';
import 'package:BOTANICAPP/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BOTANICAPP/start_screen.dart';

import 'hist_screen.dart';
//import 'package:provider/provider.dart';

class ScreenInfo extends StatefulWidget {
  final File image;
  final Map<String, dynamic> info;
  const ScreenInfo({super.key, required this.image, required this.info});

  @override
  State<ScreenInfo> createState() => _ScreenInfoState();
}

class _ScreenInfoState extends State<ScreenInfo> {
  late String user;
  bool selected = false;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenHist()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenUser()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var information = widget.info;

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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const SizedBox(
                height: 101,
              ),
              InfoCard(img: widget.image, name: information['bestMatch'])
            ],
          ),
        )
    );
  }

  Widget InfoCard({
    required File img,
    required String name,
  }){
    return Container(
        width:  MediaQuery.of(context).size.width * 0.8,
        child: Column(
        children: [
          Image.file(img, width: 300, height: 400, fit: BoxFit.cover),
          const SizedBox( height: 100,),
          Container(

              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Text(name)
                  ]
                )
            )
          )
        ],
      )
    );
  }

  Widget CustomButton( {
    required String title,
    required IconData icon,
    required VoidCallback onClick
  }) {
    return Container(
        width: 230,
        child: ElevatedButton(
          onPressed: onClick,
          child: Row(
              children: [
                Icon(icon),
                SizedBox(
                  width: 30,
                ),
                Text(title)
              ]
          ),
        )
    );
  }
}





