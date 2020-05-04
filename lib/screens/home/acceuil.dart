import 'dart:async';

import 'package:flutter/material.dart';


class HomeHelpPage extends StatefulWidget {
  @override
  _HomeHelpPageState createState() => new _HomeHelpPageState();
}

class _HomeHelpPageState extends State<HomeHelpPage> {
 
 

  @override
  Widget build(BuildContext context) {
   

    
        return new Scaffold(
          resizeToAvoidBottomInset: true,
            appBar: new AppBar(title: const Text('Page d’acceuil '), 
             backgroundColor:  Color(0xFFFF5722),
              
           
            ),
         
            body: ListView(
            children :<Widget>[
              ExpansionTile(
    
      title: Text(
                          'La map',
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
                          '\n      Dans cette map vous allez trouvez\n      votre position, et la position de chaque\n      membre du même groupe que vous.\n',


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
                          'Les groupes',
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
                          '\n       Pour choisir un groupe\n       1-Cliquez sur l’icone qui represente plusieurs\n       personnes en bas de votre page\n      2-Choisisez le groupe que vous voulez afficher.\n',


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
                          'Les membres de chaque groupe',
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
                          '\n  Pour voir la liste de membres \n  1-choisissez un  groupe\n  2-Cliquez sur l’icone qui represente une liste\n   en bas de votre page\n   Dans cette section vous pouvez voir tous\n   les membres de ce groupe \n',


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
                          'Les notifications',
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
                          '\n      Pour accèder à votre système de notifications\n      Cliquez sur l icone qui represente une cloche\n      en bas de votre page.\n',


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
         
        





        ]




        ),
        
       
        );
  }
}