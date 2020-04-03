import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User use; 

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String nom, String prenom, String identifiant, String numtel) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification(); 
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(nom,prenom, identifiant, numtel);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  //Mot de passe oublié 
  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
}


}













