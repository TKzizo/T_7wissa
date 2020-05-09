import 'dart:async';

import 'package:flutter/material.dart';


class MessageHelpPage extends StatefulWidget {
  @override
  _MessageHelpPageState createState() => new _MessageHelpPageState();
}

class _MessageHelpPageState extends State<MessageHelpPage> {
 
 

  @override
  Widget build(BuildContext context) {
   

    
        return new Scaffold(
          resizeToAvoidBottomInset: true,
            appBar: new AppBar(title: const Text('Messagerie'), 
             backgroundColor:  Color(0xFFFF5722),
              
           
            ),
         
            body: ListView(
            children :<Widget>[ ExpansionTile(
    
      title: Text(
                          'Comment accéder à la messagerie d’un groupe?',
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 18.0
                          ),
                          textAlign: TextAlign.left                
                          ),
      children: <Widget> [Text(
                          '\n  Cliquez sur l’icône qui représente un message\n  en bas de votre page.\n',


                          style: const TextStyle(
                              color:  const Color(0xde3d3d3d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left                
                          ),],),
       
              ExpansionTile(
    
      title: Text(
                          'Comment envoyer un message prédéfini?',
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 18.0
                          ),
                          textAlign: TextAlign.left                
                          ),
      children: <Widget> [Text(
                          '\n    1-Faites glisser vers le haut la liste qui se trouve\n      en bas de votre page.\n    2-Choisissez un message parmi la liste de\n      messages prédéfinis.\n    3-Cliquez sur l’icône à gauche pour envoyer.\n',


                          style: const TextStyle(
                              color:  const Color(0xde3d3d3d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left                
                          ),
       ] ),
         
               ExpansionTile(
    
      title: Text(
                          'Comment envoyer un message écrit manuellement?',
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 18.0
                          ),
                          textAlign: TextAlign.left                
                          ),
      children: <Widget> [Text(
                          '\n       1-Cliquez sur l’icône qui représente un \n        message.\n      2-Tapez votre message en bas.\n      3-Envoyez—le en appuyant sur l icône à\n        gauche.\n',


                          style: const TextStyle(
                              color:  const Color(0xde3d3d3d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left                
                          ),
       ] ),
  
       ExpansionTile(
    
      title: Text(
                          'Comment envoyer une photo?',
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 18.0
                          ),
                          textAlign: TextAlign.left                
                          ),
      children: <Widget> [Text(
                          '  1-Accèdez à la messagerie du groupe.\n  2-Cliquez sur l’icône qui représente une caméra.\n  3-Prenez une photo via votre téléphone ou bien\n   choisissez une photo de votre galerie.\n  4-Appuyez sur le bouton envoyer.\n',


                          style: const TextStyle(
                              color:  const Color(0xde3d3d3d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left                
                          ),],),
             SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                       image: AssetImage('assets/illustrationMessagerie.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
        





        ]




        ),
        
       
        );
  }
}