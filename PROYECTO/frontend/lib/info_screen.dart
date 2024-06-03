import 'dart:convert';
import 'dart:io';
import 'package:BOTANICAPP/providers/userProvider.dart';
import 'package:BOTANICAPP/storage.dart';
import 'package:BOTANICAPP/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  late Future<bool> upload;
  late CloudApi api;


  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    rootBundle.loadString('assets/credentials.json').then((json){
        api = CloudApi(json);
    });
    upload = uploadFiles();
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

  Future<bool> uploadFiles() async {
    String token = Provider.of<userProvider>(context, listen: false).token;

    var mes;
    try {
      var response = await http.post(
        Uri.parse("https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction/queries/set"),
        headers: {
          "Authentication": token,
        },
        body: {
          "name": widget.info['bestMatch'],
        }
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['status']== "ERROR"){
          mes = responseBody['message'];
          return false;
        }else if(responseBody['status']== "INVALID_TOKEN"){
          mes = responseBody['message'];
          return false;
        }
        else{
          mes = responseBody['message'];
          var filename = responseBody['data']['fileName'];
          var _imageBytes = widget.image.readAsBytesSync();
          final res = await api.save(filename, _imageBytes);
          print(res);
          return true;
        }
        print('Solicitud exitosa. Respuesta: ${response.body}');
        return mes;
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        return mes;
      }
    } catch (e) {
      print('Error durante la solicitud: $e');
      return mes;
    }
  }

  @override
  Widget build(BuildContext context) {
    var information = widget.info;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("INFORMATION"),
      ),
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
        body:  Center(
        child: FutureBuilder<bool>(
        future: upload,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se completa el Future
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay algún problema con el Future
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
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
            );
          }
        })
    ),
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





