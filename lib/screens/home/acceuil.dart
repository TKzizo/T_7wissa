/*Page d'aide de l'acceuil de l'application*/

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
/*Informations concernant la map*/
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
                          '\n      Sur cette map vous allez trouver\n      votre position, et la position de vos\n      partenaires de route appartenant au même\n      groupe.\n',
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
/*Informations concernant les groupes*/    
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
                          '\n       Pour choisir un groupe\n       1-Cliquez sur l’icône qui represente plusieurs\n       personnes en bas de votre page\n      2-Choisisez le groupe que vous voulez afficher.\n',


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
/*Informations concerant les membres*/    
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
                          '\n  Pour voir la liste des membres \n  1-Choisissez un  groupe\n  2-Cliquez sur l’icône qui represente une liste\n   en bas de votre page\n   Dans cette section vous pouvez voir tous\n   les membres de ce groupe \n',
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
/*Informations concernant les notifications*/    
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
                          "\n      Pour accèder à votre système de notifications\n      Cliquez sur l'icône qui represente une cloche\n      en bas de votre page.\n",


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
         
        
             SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                       image: AssetImage('assets/pageacceuil.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
        ]
        ),
        );
  }
}