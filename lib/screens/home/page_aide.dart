import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/screens/home/acceuil.dart';
import 'package:myapp/screens/home/assistance.dart';
import 'package:myapp/screens/home/messagerie_aide.dart';
import 'package:myapp/screens/home/profile_aide.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => new _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
 
 

  @override
  Widget build(BuildContext context) {
   

    return new Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: new AppBar(title: const Text('Aide'), 
         backgroundColor:  Color(0xFFFF5722),
          
       
        ),
     
        body: ListView(
        children :<Widget>[
        ListTile(
          leading: SizedBox(
                height:25,
                width: 25,
                child: Image(
                  image: AssetImage('profilAvatar'),
                  fit: BoxFit.contain,
                ),
              ),
          title: 
            Text(
                      'Votre profil et vos paramètres',
                      style: const TextStyle(
                          color:  const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 18.0
                      ),
                      textAlign: TextAlign.left                
                      ),
          
          subtitle: Text(
                      'Découverez comment modifier vos informations personnelles ',
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
              onTap:() =>
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        
                        ProfileHelpPage(),),
                      ),
         
        ),
        Divider(height: 15.0,color: const Color(0xFFFF5722)),
        ListTile(
            leading: SizedBox(
                height:25,
                width: 25,
                child: Image(
                  image: AssetImage(''),
                  fit: BoxFit.contain,
                ),
              ),
               title:  Text(
                      'Votre page d’acceuil',
                      style: const TextStyle(
                          color:  const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 18.0
                      ),
                      textAlign: TextAlign.left                
                      ),
          
          subtitle: Text(
                      'Découverez comment fonctionne votre page principale, comment contrôler ce qui y apparaît',
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
            onTap:() =>
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        
                        HomeHelpPage(),),
                      ),
         ),
         Divider(height: 15.0,color: const Color(0xFFFF5722),),
        ListTile( 
            leading: SizedBox(
                height:25,
                width: 25,
                child: Image(
                  image: AssetImage(''),
                  fit: BoxFit.contain,
                ),
              ),title: 
            Text(
                      'Messagerie',
                      style: const TextStyle(
                          color:  const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 18.0
                      ),
                      textAlign: TextAlign.left                
                      ),
          
          subtitle:
           Text(
                      'Trouvez les réponses à vos questions concernant l envoi et la réception de messages',
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
                      onTap:() =>
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        
                        MessageHelpPage(),),
                      ),
         ),
         Divider(height: 15.0,color:const  Color(0xFFFF5722)),
        ListTile(  leading: SizedBox(
                height:25,
                width: 25,
                child: Image(
                  image: AssetImage(''),
                  fit: BoxFit.contain,
                ),
              ), title: 
            Text(
                      'Espace d assistance',
                      style: const TextStyle(
                          color:  const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 18.0
                      ),
                      textAlign: TextAlign.left                
                      ),
          
          subtitle: Text(
                      'N hesitez pas à poser vos questions, aidez nous à amiliorer cette version',
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
                      onTap:() =>
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        
                        AssistanceHelpPage(),),
                      ),
                      
         ),





        ]




        ),
        
       
        );
  }
}