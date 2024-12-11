/*Création de groupe*/

import 'package:cloud_firestore/cloud_firestore.dart';
class CreationGroupeServises {
  final String uid;
  CreationGroupeServises({ this.uid });
  // Access a Cloud Firestore instance from your Activity
//final databaseReference = Firestore.instance;
final CollectionReference chatCollection = Firestore.instance.collection('chat');
final CollectionReference groupeCollection = Firestore.instance.collection('groupe');
final CollectionReference utilisateurCollection = Firestore.instance.collection('utilisateur');

  Future creerGroupe(String admin, String dist, String heure , List<dynamic> listMembre , String nom,String adminID) async {
    try {
      groupeCollection.document(uid).collection('ListeMembre').document('zzzzzzzzzzzzzz').setData({
        'user': 'membreDefaut', 
      });
      groupeCollection.document(uid).collection('ListeMembre').document().setData({
        'user': adminID, 
      });
      groupeCollection.document(uid).collection('Markers').document().setData({
        'image': ''
      });
     groupeCollection.document(uid).setData
      ({
        'admin': admin,
        'destination': dist,
        'heureDepart': heure,
        'nom':nom,
        'statu': true ,
        'uid' : this.uid,
      });
      utilisateurCollection.document(adminID).collection('ListeGroupe').document().setData({
      'id': this.uid,
      });
      chatCollection.document(uid).collection('messages').document().setData({}); // your answer missing *.document()*  before setData
       chatCollection.document(uid).setData({});
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
  Future marquer_Alerte(String id, String text,double longitude,double latitude, String senderId, String icon ) async{
    try {
       groupeCollection.document(id).collection('Markers').document().setData
      ({
        'text': text,
        'senderId': senderId,
        'longitude':longitude, 
        'latitude': latitude, 
        'icon': icon, 
      });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
  
  
}