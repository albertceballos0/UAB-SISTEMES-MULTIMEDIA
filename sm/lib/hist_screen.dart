import 'dart:convert';
import 'dart:io';
import 'package:BOTANICAPP/providers/userProvider.dart';
import 'package:BOTANICAPP/storage.dart';
import 'package:BOTANICAPP/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BOTANICAPP/start_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';




class ScreenHist extends StatefulWidget {
  const ScreenHist({super.key});

  @override
  State<ScreenHist> createState() => _ScreenHistState();
}

class _ScreenHistState extends State<ScreenHist> {
  late String user;
  bool selected = false;
  late int _selectedIndex;
  late Future<List<dynamic>?> hist;
  late CloudApi api;


  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    hist = getHist();
    rootBundle.loadString('assets/credentials.json').then((json){
      api = CloudApi(json);
    });
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
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenUser()),
      );
    }
  }
  Future<List<dynamic>?> getHist() async {
    String token = Provider.of<userProvider>(context, listen: false).token;

    var mes;
    try {
      var response = await http.get(
          Uri.parse("https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction/queries/get"),
          headers: {
            "Authentication": token,
          },
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['status']== "ERROR"){
          mes = responseBody['message'];
          return null;
        }else if(responseBody['status']== "INVALID_TOKEN"){
          mes = responseBody['message'];
          return null;
        }
        else{
          mes = responseBody['message'];
          return responseBody['data'];
        }
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
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'USER',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Center(
            child: FutureBuilder<List<dynamic>?>(
            future: hist,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se completa el Future
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si hay algún problema con el Future
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(
                      30.0
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      courseLayout(context, snapshot.data),
                    ],
                  ),
                );
              }
            }),
        )
    );
  }

  Widget courseLayout(BuildContext context, var all) {
    var height = MediaQuery.of(context).size.height * 0.25;
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 27,
      crossAxisSpacing: 23,
      itemCount: all.length,
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
                    height: height * 0.7,
                    child: CachedNetworkImage(
                      imageUrl: "", // Proporciona la URL de la imagen desde la lista 'all'
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Muestra un indicador de carga mientras se descarga la imagen
                      errorWidget: (context, url, error) => Icon(Icons.error), // Muestra un ícono de error si no se puede cargar la imagen
                    ),
                  ),
                  SizedBox(height: height*0.05,),
                Expanded(
                    child: Text(
                      all[index]['name'],
                      maxLines: 2, // Limitar a dos líneas
                      overflow: TextOverflow.ellipsis, // Manejar el desbordamiento con puntos suspensivos
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                )
                ]
              )

            )
          )
        );
      },
    );
  }


}





