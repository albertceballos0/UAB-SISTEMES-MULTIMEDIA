import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BOTANICAPP/start_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
          padding: const EdgeInsets.all(
            30.0,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              courseLayout(context, 15),
            ],
          ),
        )
    );
  }

  Widget courseLayout(BuildContext context, int number) {
    var height = MediaQuery.of(context).size.height * 0.25;
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 27,
      crossAxisSpacing: 23,
      itemCount: number,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Container(
              height: height,
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                      color: Colors.black12,
                      height: height*0.7,
                  ),
                  SizedBox(height: height*0.05,),
                  Text("MIAU")
                ]
              )

            )
          )
        );
      },
    );
  }


}





