import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference utilisateurCollection = Firestore.instance.collection('utilisateur');

  Future<void> updateUserData(String identifiant, String numtel, int vitesse) async {
    return await utilisateurCollection.document(uid).setData({
      'identifiant': identifiant,
      'numtel': numtel,
      'vitesse': vitesse,
    });
  }

}