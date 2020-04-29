import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference utilisateurCollection = Firestore.instance.collection('utilisateur');

  Future<void> updateUserData(String nom, String prenom, String identifiant, String numtel) async {
    utilisateurCollection.document(uid).collection('ListeGroupe').document().setData({}); 
    utilisateurCollection.document(uid).collection('Invitations').document().setData({});
    return await utilisateurCollection.document(uid).setData({
      'nom': nom,
      'prenom' :prenom, 
      'identifiant' :identifiant, 
      'numtel': numtel,
      'uid': uid, 
      'longitude': null, 
      'latitude': null, 
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
       ); 
     
     }
   
    //get user stream 
   Stream<UserData> get utilisateursDonnees{
      return utilisateurCollection.document(uid).snapshots()
      .map(_userDataFromSnapchot); 
    }
}