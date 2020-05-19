/*Messagerie*/

import 'package:cloud_firestore/cloud_firestore.dart';
class ChatService {
    final String uid;
     ChatService({ this.uid });
    
  final CollectionReference chatCollection = Firestore.instance.collection('chat');
    
 /*Méthode envoyer message le champs text est à null lorsqu'on envoie une image et le champs image est à null lorsqu'on envoie un message texte*/  
  Future envoyer_mesg(String id, String text, String sender, String senderId,String imageUrl) async{
    try {
      chatCollection.document(id).collection('messages').document().setData
      ({
        'text': text,
        'sender': sender, 
        'senderId': senderId,
        'time': DateTime.now().toString(),     
        'image':imageUrl,
      });
    } catch (error) {
      print(error.toString()); 
      return null;
    } 
  }
}
