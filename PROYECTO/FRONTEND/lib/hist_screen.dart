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

import 'info_screen2.dart';




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
                      snapshot.data!.isEmpty ?
                      Center(
                        child: Container(
                          width: 230,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,          // Remove shadow/elevation
                              shadowColor: Colors.transparent, // Remove shadow color
                              side: BorderSide.none, // Remove border
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("EMPTY HISTORY")
                              ],
                            ),
                          ),
                        ),
                      )
                      :
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
    return  all.length == 0 ?
         Center(
             child: Container(
              width: 230,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,          // Remove shadow/elevation
                  shadowColor: Colors.transparent, // Remove shadow color
                  side: BorderSide.none, // Remove border
                ),
                onPressed: () {},
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("EMPTY HISTORY")
                    ]
                ),
              ),
            ),
        )
        : MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 27,
      crossAxisSpacing: 23,
      itemCount: all.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (
                  context) => ScreenInfo2(image: all[index]['fileName']!, info: all[index]['name'])),
            );
          },
          child: Container(
              height: height,
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                    height: height * 0.7,
                    child: Expanded(child: Image.network(
                      all[index]['fileName'],
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Text('Failed to load image');
                      },
                    ),
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





