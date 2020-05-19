/*Modification de la photo de profile*/

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';



class ProfilPicture extends StatefulWidget {
 @override
  createState() => _ProfilPictureState();  
}

class _ProfilPictureState extends State<ProfilPicture> {
File _imageFile;
Future<void> _pickImage(ImageSource source)async{
 File selected = await ImagePicker.pickImage(source: source);
 setState(() {
   _imageFile = selected;
 });
}

void _clear(){
  setState(() => _imageFile =null 
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        title: const Text('Modifier la photo de profil '),
        backgroundColor:  Color(0xFFFF5722),
      ),
   bottomNavigationBar: BottomAppBar(
    child :Row  (
      mainAxisAlignment: MainAxisAlignment.spaceAround,
     children :<Widget>[
       
       IconButton(
         icon:Icon(Icons.photo_camera,
         color: Colors.greenAccent,)
          ,
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
   Uploader(file:_imageFile)
  ]
 ],
 ),
    );
  }
 }

/*Upload la nouvelle photo dans la base de données*/
 class Uploader extends StatefulWidget{
  final File file;
   Uploader({Key key,this.file }):super(key : key);
  createState()=>_UploaderState();
 }
 class _UploaderState extends State<Uploader>{
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
    /*Get url from the image bucket*/
    String url = await _startUpLoad();
   
    final user = Provider.of<User>(context);
    String _current_userId;

    /*Récupère l'id de l'utilisateur courant*/ 
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){ 
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      _current_userId= userData.uid; 
                      return  Text(
                          userData.identifiant);
                    }else{
                      print('object');
                      return Text('Loading');
                    }
                  });

  /* Fontion qui ajoute l'image dans la DataBase*/
   DatabaseService(uid:_current_userId.toString()).addPhoto(url);
  }
   
  @override
  Widget build(BuildContext context) {
    /* Vérification si une photo a été bien choisie*/
    if (_uploadTask != null){
      return Container();
    /*si oui, affichage d'un bouton modifier*/
    }else{
      return FlatButton.icon(
       label: Text('Modifier'),
       icon: Icon(Icons.check_circle,
       color: Colors.greenAccent,),
       onPressed:(){
        uploadImage();
        }
      );
    }
  }
}