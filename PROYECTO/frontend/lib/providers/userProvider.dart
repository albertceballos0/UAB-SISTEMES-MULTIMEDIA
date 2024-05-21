import 'dart:convert';
import 'package:flutter/cupertino.dart';

class userProvider extends ChangeNotifier{
  late String _user;
  late int _id;
  late String _token;

  get http => null;

  MyDataProvider() {
  }

  String get user => _user;
  int get id => _id;

  Future<bool> logIn(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:8000/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        _token = responseBody['token'];
        _id = responseBody['id'];
        _user = username;
        print('Solicitud exitosa. Respuesta: ${response.body}');
        return true;
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error durante la solicitud: $e');
      return false;
    }
  }

  Future<bool> registerUser(String username, String password, String email) async {
    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:8000/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email
        }),
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        _token = responseBody['token'];
        print('Solicitud exitosa. Respuesta: ${response.body}');
        return true;
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error durante la solicitud: $e');
      return false;
    }
  }

  Future<bool> editPassword(String username, String password, String newPassword) async {
    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:8000/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "newPassword": newPassword
        }),
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        _token = responseBody['token'];
        print('Solicitud exitosa. Respuesta: ${response.body}');
        return true;
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error durante la solicitud: $e');
      return false;
    }
  }
}