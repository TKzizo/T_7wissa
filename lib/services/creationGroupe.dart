import 'package:cloud_firestore/cloud_firestore.dart';
class CreationGroupeServises {
  final String uid;
  CreationGroupeServises({ this.uid });
  // Access a Cloud Firestore instance from your Activity
final databaseReference = Firestore.instance;
final CollectionReference chatCollection = Firestore.instance.collection('chat');

  Future creerGroupe(String admin, String dist, String heure , List<dynamic> listMembre , String nom) async {
    try {
     Firestore.instance.collection("groupe").document(uid).setData
      ({
        'admin': admin,
        'destination': dist,
        'heureDepart': heure,
        'liste_membre': listMembre,
        'nom':nom,
        'statu': true ,
        'messagerie_uid': uid,
      });
       chatCollection.document(uid).setData({
       
    });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
}