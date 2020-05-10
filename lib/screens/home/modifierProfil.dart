import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/authenticate/forgot_pswd.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/screens/authenticate/register.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => new _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //champs
  String nom= '';
  String email= '';
  String password='';
  String passwordNew='';
  String prenom = '';
  String utilisateur = '';
  String phoneNumber;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  
  String error ='';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user1;
  FirebaseUser currentUser;
   FocusNode _focusNode = new FocusNode();
  void _loadCurrentUser()async {
   await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }
  @override
  void initState() {
    super.initState();
    initUser();
          _focusNode.addListener(_focusNodeListener);
  }

  initUser() async {
    user1 = await _auth.currentUser();
    setState(() {});
  
  }
  @override
    void dispose(){
        _focusNode.removeListener(_focusNodeListener);
        super.dispose();
    }
Future<Null> _focusNodeListener() async {
        if (_focusNode.hasFocus){
            print('TextField got the focus');
        } else {
            print('TextField lost the focus');
        }
    }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();
    final user = Provider.of<User>(context);
   

    return new Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: new AppBar(title: const Text('Modifier le profil'), 
         backgroundColor:  Color(0xFFFF5722),
           
       
        ),
        body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).utilisateursDonnees,
          builder: (context,snapshot){
            if (!snapshot.hasData){
          return Text(
              'Chargement de données ..!',
                      style: const TextStyle(
                          color:  const Color(0xde000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 17.0
                      ),
                      textAlign: TextAlign.left                
                      );
     

            }

           else{
              UserData userData =snapshot.data;
             
             return  SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                 Column(children: <Widget>[
          Form(
          key : _formKey,
      child: Column( 
        
        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0),
              TextFormField(
                initialValue: userData.nom,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.person,
                  color:  Colors.teal),
                 
                 labelText: 'Nom *',
                    ),
                validator: (val) => val.isEmpty ? 'Donner un nom ' : null,
                onChanged: (val) {
                  setState(() => nom = val);
                },
              ),
              SizedBox(height: 15.0),
               TextFormField(
                initialValue:userData.nom,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.person,
                 color:  Colors.teal),
               
                 labelText: 'Prénom *',
                    ),
                validator: (val) => val.isEmpty ? 'Donner un Prénom ' : null,
                onChanged: (val) {
                  setState(() => prenom = val);
                },),
              SizedBox(height: 15.0),
              TextFormField(
                initialValue: userData.identifiant,
                 decoration: const InputDecoration(
                 icon: Icon(null),
                
                 labelText: 'Nom d utilisateur  *',
                    ),
                validator: (val) => val.isEmpty ? 'Donner votre nom d utilisateur ' : null,
                onChanged: (val) {
                  setState(() => utilisateur = val);
                },),

                TextFormField(
                initialValue: userData.numtel,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.phone,
                 color:  Colors.teal),
                 
                 labelText: 'Num de tél *',
                    ),
                validator: (val) => val.isEmpty ? 'Donner votre nom d utilisateur ' : null,
                onChanged: (val) {
                  setState(() => phoneNumber = val);
                },),
                FutureBuilder(
                 future: FirebaseAuth.instance.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                 if (snapshot.hasData) {
                 return   TextFormField(
                initialValue: snapshot.data.email,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.mail,
                 color:  Colors.teal),
                 
                 labelText: 'Email *',
                    ),
                validator: (val) => val.isEmpty ? 'Donner une adresse ' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },);
          
          
          
        }
        else {
          return Text('Loading...');
        }
      },
    ),
  
            
                TextFormField(
                 
                 obscureText: true,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.vpn_key,
                 color:  Colors.teal),
                 hintText: 'entrer votre mot de passe',
                 labelText: 'Mot de passe actuel *',
                    ),
                  validator: (val) => val.length < 6 ? 'Mot de passe érroné' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },),
                      TextFormField(
                 controller: _pass,
                 obscureText: true,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.remove_red_eye,
                 color:  Colors.teal),
                 hintText: 'entrer votre nouveau mot de passe',
                 labelText: 'Nouveau mot de passe *',
                    ),
               
                    onChanged: (val) {
                      setState(() => passwordNew = val);
                    },),
                    
                       TextFormField(
                          
                         controller: _confirmPass,
                  //Validation de l'entrée
                  validator: (val){
                              
                              if(val != _pass.text)
                                   return 'Not Match';
                              return null;
                              }, 
                 obscureText: true,
                 decoration: const InputDecoration(
                 icon: Icon(Icons.remove_red_eye,color:  Colors.teal),
                 hintText: 'Confirmer votre nouveau mot de passe',
                 
                    ),
             
                    onChanged: (val) {
                      setState(() => passwordNew = val);
                    },),
                /*Mot de passe oublié*/
                SizedBox(height: 30),
                Material(

                  child: FlatButton(
                    child:
                    Text("Mot de passe oublié ?",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: const Color(0xff7966ff),
                          fontFamily: "Roboto-light",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgotpswd()),
                      );
                    },
                  ),
                ),

                /*Mot de passe oublié*/
               Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: new MaterialButton(
                color: Color(0xFFFF7043),
                textColor: themeData.secondaryHeaderColor,
                child: new Text('Sauvegarder'),
                 onPressed: () async {
            
          if(_formKey.currentState.validate() )
                {   await DatabaseService(uid: user.uid).updateUserData(
                  nom,prenom,utilisateur,phoneNumber
                );
                
                 }
                  Navigator.pop(context);
                },
              ))
               
            ],
          ),
        ),  ])
               ],
             ),
           );
        
       
        
         }
          }
        )
        
        
        
       
        );
  }
  
}