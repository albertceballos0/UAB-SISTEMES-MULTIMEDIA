import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class userProvider extends ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  late int _id;
  late String _token;

  MyDataProvider() {
  }

  User? get user => _user;
  String get token => _token;
  int get id => _id;

  bool isUser(){
    if (_user != null){
      return true;
    }
    return false;
  }

  Future<bool> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      if (_user != null) {
        // Inicio de sesión exitoso
        print (_user);
        await getToken();
        return true;
      } else {
        // El inicio de sesión falló
        return false;
      }
    } catch (error) {
      print('Error en el inicio de sesión: $error');
      return false;
    }
  }
  Future<void> signOut() async {
    try {
      // Cerrar sesión con FirebaseAuth
      await _auth.signOut();

      // Cerrar sesión con GoogleSignIn
      await _googleSignIn.signOut();

      // Notificar a los escuchadores que el estado ha cambiado
      notifyListeners();
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }

  Future<void> getToken() async {
    try {
      var response = await http.post(
        Uri.parse("https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction/users/auth"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": _user!.email,
        }),
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        _token = responseBody['token'];
        print('Solicitud exitosa. Respuesta: ${response.body}');
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error durante la solicitud: $e');
    }
  }
}