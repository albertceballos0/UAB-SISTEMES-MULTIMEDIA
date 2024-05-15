import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm/start_screen.dart';

import 'hist_screen.dart';
//import 'package:provider/provider.dart';

class ScreenInfo extends StatefulWidget {
  final File image;
  const ScreenInfo({super.key, required this.image});

  @override
  State<ScreenInfo> createState() => _ScreenInfoState();
}

class _ScreenInfoState extends State<ScreenInfo> {
  late String user;
  bool selected = false;
  int _selectedIndex = 0;



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
      ) :
    Navigator.push(
      context,
      MaterialPageRoute(builder: (
          context) => const ScreenHist()),
    );
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
            children: [
              const SizedBox(
                height: 100,
              ),
              InfoCard(img: widget.image)
            ],
          ),
        )
    );
  }

  Widget InfoCard({
    required File img
  }){
    return Container(
      child: Column(
        children: [
          Image.file(img, width: 250, height: 250, fit: BoxFit.cover),
          const SizedBox( height: 100,),
          Text("namee")
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





