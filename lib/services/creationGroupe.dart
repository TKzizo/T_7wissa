import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
class CreationGroupeServises {
  final String uid;
  CreationGroupeServises({ this.uid });
  // Access a Cloud Firestore instance from your Activity
//final databaseReference = Firestore.instance;
final CollectionReference chatCollection = Firestore.instance.collection('chat');
final CollectionReference groupeCollection = Firestore.instance.collection('groupe');

  Future creerGroupe(String admin, String dist, String heure , List<dynamic> listMembre , String nom) async {
    try {
      groupeCollection.document(uid).collection('ListeMembre').document().setData({});
      groupeCollection.document(uid).collection('Markers').document().setData({});

     groupeCollection.document(uid).setData
      ({
        'admin': admin,
        'destination': dist,
        'heureDepart': heure,
        
        'nom':nom,
        'statu': true ,
        'uid' : this.uid,
      });
      chatCollection.document(uid).collection('messages').document().setData({
        
      }); // your answer missing *.document()*  before setData

       chatCollection.document(uid).setData({
       
    });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
  Future marquer_Alerte(String id, String text,Position position, String senderId, String icon ) async{
    try {
       groupeCollection.document(id).collection('Markers').document().setData
      ({
        'text': text,
        'senderId': senderId,
        'position':position.toJson(), 
        'icon': icon, 
      });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
  
  
}