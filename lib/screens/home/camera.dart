/* Envoi d'une photo*/

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';



class ImageCapture extends StatefulWidget {

  final String groupeID;
  ImageCapture({this.groupeID});
  
 @override
  createState() => _ImageCaptureState(groupeID: this.groupeID);   
}

 class _ImageCaptureState extends State<ImageCapture> {
   final String groupeID;
  _ImageCaptureState({this.groupeID});
 File _imageFile;

/*Sélectionner ou prendre une photo*/
Future<void> _pickImage(ImageSource source)async{
 File selected = await ImagePicker.pickImage(source: source);
 setState(() {
   _imageFile = selected;
 });
}

/*Possiblité de reprendre la photo*/
void _clear(){
  setState(() => _imageFile =null   
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        title: const Text('Envoyer une image '),
        backgroundColor:  Color(0xFFFF5722),
      ),
   bottomNavigationBar: BottomAppBar(
    child :Row  (
      mainAxisAlignment: MainAxisAlignment.spaceAround,
     children :<Widget>[ 
       IconButton(
         icon:Icon(Icons.photo_camera,
         color: Colors.greenAccent,),
         onPressed:()=>_pickImage(ImageSource.camera) ,),
         IconButton(
         icon:Icon(Icons.photo_library,
         color: Colors.greenAccent,) ,
         onPressed:()=>_pickImage(ImageSource.gallery) ,),
     ]
 ),
 ),
 body: ListView(
 children:<Widget>[
/*Affichage de la photo choisie par l'utilisateur*/
  if(_imageFile != null)...[
   Image.file(_imageFile) ,
   Row(
     children: <Widget>[
       FlatButton(
         onPressed: _clear, 
         child: Icon(Icons.refresh)),
     ],
   ),
   Uploader(file:_imageFile,groupeID: groupeID,)
  ]
 ],
 ),
    );
  }
 }

/*Uploade la photo dans la base de données*/
 class Uploader extends StatefulWidget{
   final String groupeID ;
   

  final File file;
   Uploader({Key key,this.file,this.groupeID }):super(key : key);
  createState()=>_UploaderState(groupeID: groupeID);
 }
 class _UploaderState extends State<Uploader>{
   final String groupeID ;
   _UploaderState({this.groupeID});
  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: 'gs://myapp-4df98.appspot.com'
  );
  StorageUploadTask _uploadTask;
  Future<String> _startUpLoad()async{
   try {String filePath ='images/${DateTime.now()}.png';
    setState(() {
    _uploadTask = _storage.ref().child(filePath).putFile(widget.file);  
    });
    var url = await (await _uploadTask.onComplete).ref.getDownloadURL();
   return url ;}catch(e){
     print(e);
     return null;
   }
  }

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }
  void uploadImage(
      ) async {
    String url = await _startUpLoad();
    
    /*Hide loading*/
    final user = Provider.of<User>(context);
    String _current_user; 
    String _current_userId; 
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      
                      _current_user= userData.identifiant; 
                      _current_userId= userData.uid; 

                      return  Text(
                          userData.identifiant);
                    }else{
                      return Text('Loading');
                    }
                  });
    ChatService(uid: groupeID.toString() ).envoyer_mesg(groupeID.toString(),null, _current_user,_current_userId,url); 
  }
   
  @override
  Widget build(BuildContext context) {
    /*Vérification si une photo a été bien choisie*/
    if (_uploadTask != null){
      return Container();
    /*si oui, affichage d'un bouton envoyer*/
    }else{
      return FlatButton.icon(
       label: Text('Envoyer'),
       icon: Icon(Icons.cloud_upload,
       color: Colors.greenAccent,),
       onPressed:(){
        uploadImage(); 
        }
      );
    }
  }
}