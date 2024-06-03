import 'dart:convert';
import 'dart:io';
import 'package:BOTANICAPP/providers/userProvider.dart';
import 'package:BOTANICAPP/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'hist_screen.dart';
import 'info_screen.dart';
import 'package:provider/provider.dart';

class ScreenStart extends StatefulWidget {

  const ScreenStart({super.key});

  @override
  State<ScreenStart> createState() => _ScreenMenuState();
}

class _ScreenMenuState extends State<ScreenStart> {
  late String user;
  late Future<String> message;
  late int count;
  late bool search;
  bool selected = false;
  late int _selectedIndex;
  File? _image;
  File imageFile = File('../assets/plant.png');

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.selected = true;
        this._image = imageTemporary;
      });
    } on PlatformException catch (e){
      print("Failed to pivk image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    message = getMessage();
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

  void _newOne() {
    setState(() {
      selected = false;
      _image = null;
    });
  }

  Future<void> _search(File file) async {
    // Inicializa la solicitud multipart
    var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://my-api.plantnet.org/v2/identify/all?include-related-images=false&no-reject=false&lang=en&api-key=2b10L1tahU8SiL0Mt0la2DJBu'),
    );

    // Añade los encabezados
    request.headers['accept'] = 'application/json';
    request.headers['Content-Type']= 'multipart/form-data';

    // Añade el archivo a la solicitud
    request.files.add(
      http.MultipartFile(
      'images', // Nombre del campo para el archivo según la API de PlantNet
      file.openRead(),
      await file.length(),
      filename: file.path.split('/').last,
      contentType: MediaType('image', 'jpeg'), // Ajusta el tipo MIME si es necesario
      ),
    );
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseMapped = json.decode(responseBody);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (
              context) => ScreenInfo(image: _image!, info: responseMapped)),
        );
      } else {
        setState(() {
          selected = false;
          _image = null;
        });
        Fluttertoast.showToast(
            msg: "Error: Image not identified",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.redAccent,
            textColor: Colors.black,
            fontSize: 16.0
        );
        print('Research failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> getMessage() async {
    String token = Provider.of<userProvider>(context, listen: false).token;
    var mes = "";
    try {
      var response = await http.get(
        Uri.parse("https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction/queries/count"),
        headers: {
          "Authentication": token,
        },
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['status']== "ERROR"){
          mes = responseBody['message'];
          search = false;
        }else if(responseBody['status']== "INVALID_TOKEN"){
          mes = responseBody['message'];
          search = false;
        }
        else{
          search = true;
          count = responseBody['data'];
          mes = "$count tries remaining";
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

  Future<void> lol(File file)  async {
    String token = Provider.of<userProvider>(context, listen: false).token;
    var request = http.MultipartRequest('POST', Uri.parse('https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction/queries/set'));
    request.headers['Authentication'] = token;
    // Añade los encabezados
    request.headers['accept'] = 'application/json';
    request.headers['Content-Type']= 'multipart/form-data';

    // Añade el archivo a la solicitud
    request.files.add(
      http.MultipartFile(
        'images', // Nombre del campo para el archivo según la API de PlantNet
        file.openRead(),
        await file.length(),
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'jpeg'), // Ajusta el tipo MIME si es necesario
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        Navigator.push(
        context,
        MaterialPageRoute(builder: (
        context) => ScreenInfo(image: _image!, info: {},)),
        );
      } else {
        print('Research failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

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
              child: FutureBuilder<String>(
              future: message,
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
                      horizontal: 30.0,),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          pickImage(selected: selected, message: snapshot.data!)
                        ],
                      )
                    );
              }}
    )
    ),);
  }

  Widget pickImage( { required bool selected , required String message}){
    return
      !selected ?
      Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(16.0),
              height: 400,
              width: 300,
              child: _image != null
                    ? Image.file(_image!, width: 300, height: 400, fit: BoxFit.cover)
                    : Image(image: AssetImage('./assets/plant.png'))
            ),
            Container(
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
                            Text(message)
                          ]
                      ),
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            CustomButton(title: "Pick from gallery", icon: Icons.image_outlined, onClick: () => getImage(ImageSource.gallery) ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(title: "Pick from camera", icon: Icons.camera, onClick: () => getImage(ImageSource.camera) ),

          ]
      ),
    )
    :
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        _image != null
        ? Image.file(_image!, width: 300, height: 400, fit: BoxFit.cover)
            : Image(image: AssetImage('../assets/plant.png')),
        const SizedBox(
        height: 50,
        ),
        CustomButton(title: "NEW ONE", icon: Icons.replay, onClick: () => _newOne() ),
        const SizedBox(
        height: 20,
        ),
        CustomButton(title: "SEARCH", icon: Icons.search, onClick: () => search ? _search(_image!) : ()),
        ]
        ),
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





