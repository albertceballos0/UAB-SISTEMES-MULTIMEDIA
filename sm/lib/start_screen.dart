import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';




class ScreenStart extends StatefulWidget {
  final CameraDescription? camera;

  const ScreenStart({super.key, required this.camera});

  @override
  State<ScreenStart> createState() => _ScreenMenuState();
}

class _ScreenMenuState extends State<ScreenStart> {
  late String user;
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e){
      print("Failed to pivk image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                height: 20,
              ),
                  Container(
                    child:
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       _image != null
                         ? Image.file(_image!, width: 250, height: 250, fit: BoxFit.cover)
                         : Image.asset(
                          '../assets/plant.png',
                          width: 250,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        CustomButton(title: "Pick from gallery", icon: Icons.image_outlined, onClick: () => getImage(ImageSource.gallery) ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(title: "Pick from camera", icon: Icons.camera, onClick: () => getImage(ImageSource.camera) ),

                      ]
                  ),
                  ),
                ],),
          ),
    );
  }

  Widget CustomButton( {
    required String title,
    required IconData icon,
    required VoidCallback onClick
  }) {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(title)
          ]
        ),
      )
    );
  }
}





