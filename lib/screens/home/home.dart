
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
        final user = Provider.of<User>(context);

        return  Container(
          child: Scaffold(
           key: _scaffoldKey,
            backgroundColor: Colors.white,
                       
            /*Bar*/ 
                       
            /*MENU*/ 
            
            body:  Material(
                            elevation: 0,

                             child: Builder(
                                builder: (context) => FloatingActionButton(onPressed: () => Scaffold.of(context).openDrawer(),),
                              ),
                          ),
            drawer: Drawer(
               child: Column(
                         children: [
                           Expanded(
                             flex: 1,
                             child: SizedBox(
                                   height:250,
                                   width: 250,
                                   child: Image(
                             image: AssetImage('assets/avatar.png'),
                              fit: BoxFit.contain,
                            ),
                                 ),
                           ),
                           Expanded(
                             flex: 1,
                             child: StreamBuilder<UserData>(
                               stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                               builder: (context,snapshot){
                                 if(snapshot.hasData){
                                   UserData userData=snapshot.data; 
                                    print(userData.identifiant); 
                                   return  Text(
                                        userData.identifiant); 
                                 }else{
                                   return Text('Loading'); 
                                   
                                 }
                                 
                                    
                               }
                             ),
                           ), 
                           Expanded(
                             flex: 2,
                             child: ListView(children: [
                               ListTile(
                                   leading: Icon(Icons.settings, color: Colors.greenAccent,),
                                   title: Text('Paramètres du compte'), 
                                 onTap: () async {
                                   Navigator.of(context).pop();
                                   
                                 },
                               ),
                               ListTile(
                                 leading: Icon(Icons.info,color: Colors.greenAccent, ),
                                 title: Text("Aide"),
                                 onTap: () {
                                   Navigator.of(context).pop();
                                 },
                               ),
                               ListTile(
                                 leading: Icon(Icons.share,color: Colors.greenAccent,),
                                 title: Text("Partager l'application"),
                                 onTap: () {
                                   Navigator.of(context).pop();
                                 },
                               ),
                               SizedBox(height: 12,), 
                               ListTile(
                                leading: Icon(Icons.done_outline, color: Colors.greenAccent,),
                                 title: Text("Déconnexion"),
                                 onTap: () async { 
                                  await _auth.signOut();            
                                 },
                               ),
                             ]),
                           )
                         ],
                       ),
                       ), 
                      )
                      
                         );
            
            }
   
       
    
  }

