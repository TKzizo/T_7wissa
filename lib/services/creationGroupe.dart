import 'package:cloud_firestore/cloud_firestore.dart';
class CreationGroupeServises {
  // Access a Cloud Firestore instance from your Activity
final databaseReference = Firestore.instance;
  Future creerGroupe(String admin, String dist, String heure , List<dynamic> listMembre , String nom) async {
    try {
     Firestore.instance.collection("groupe").document().setData
      ({
        'admin': admin,
        'destination': dist,
        'heureDepart': heure,
        'liste_membre': listMembre,
        'nom':nom,
        'statu': true ,
        'messagerie': null ,
      });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
}