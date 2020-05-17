import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference utilisateurCollection = Firestore.instance.collection('utilisateur');

  Future<void> updateUserData(String nom, String prenom, String identifiant, String numtel) async {
    utilisateurCollection.document(uid).collection('ListeGroupe').document('zzzzzzzzzzzzzz').setData({
      
      'id':'10000000', 
  
    }); 
    utilisateurCollection.document(uid).collection('Invitations').document().setData({
      'groupe':'',
      'groupeID': '',
      'admin':'', 
      'destination': '',

    });
    return await utilisateurCollection.document(uid).setData({
      'nom': nom,
      'prenom' :prenom, 
      'identifiant' :identifiant, 
      'numtel': numtel,
      'uid': uid, 
      'longitude': null, 
      'latitude': null, 
      'image_url': 'https://firebasestorage.googleapis.com/v0/b/myapp-4df98.appspot.com/o/images%2FPlan%20de%20travail%201.png?alt=media&token=4a5c6bb5-07a1-4333-8021-6515a41103b6',
    },
    );
    
    
  }
 

  //user data from snapshot 
   UserData _userDataFromSnapchot(DocumentSnapshot snapshot){
     return UserData( 
       uid: uid,
       identifiant: snapshot.data['identifiant'],
       nom: snapshot.data['nom'],
       prenom: snapshot.data['prenom'], 
       numtel: snapshot.data['numtel'], 
       longitude: snapshot.data['longitude'],
       latitude: snapshot.data['latitude'], 
       vitesse: snapshot.data['vitesse'], 
       image_url: snapshot.data['image_url']
       ); 
     
     }
   
    //get user stream 
   Stream<UserData> get utilisateursDonnees{
      return utilisateurCollection.document(uid).snapshots()
      .map(_userDataFromSnapchot); 
    }
    
    
    
    Future addPhoto(String url) async{
  try{
      utilisateurCollection.document(uid).updateData({
        'image_url':url,
      });
  }catch (error) {
      print(error.toString()); 
      return null;
    } 

  }
}