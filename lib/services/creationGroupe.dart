import 'package:cloud_firestore/cloud_firestore.dart';
class CreationGroupeServises {
  final String uid;
  CreationGroupeServises({ this.uid });
  // Access a Cloud Firestore instance from your Activity
//final databaseReference = Firestore.instance;
final CollectionReference chatCollection = Firestore.instance.collection('chat');
final CollectionReference groupeCollection = Firestore.instance.collection('groupe');

  Future creerGroupe(String admin, String dist, String heure , List<dynamic> listMembre , String nom) async {
    try {
     groupeCollection.document(uid).setData
      ({
        'admin': admin,
        'destination': dist,
        'heureDepart': heure,
        'liste_membre': listMembre,
        'nom':nom,
        'statu': true ,
        'uid' : this.uid,
      });
      chatCollection.document(uid).collection('messages').document().setData({
        
      }); // your answer missing **.document()**  before setData

       chatCollection.document(uid).setData({
       
    });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
  void sendtext(String sender, String message ){
    
  }
}