import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential = _auth.createUserWithEmailAndPassword(email: email, password: password) as UserCredential;
      return credential.user;
    }catch (e){
      print("Error: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential = _auth.signInWithEmailAndPassword(email: email, password: password) as UserCredential;
      return credential.user;
    }catch (e){
      print("Error: $e");
    }
    return null;
  }
}

