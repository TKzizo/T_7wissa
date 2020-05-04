import 'dart:async';

import 'package:flutter/material.dart';


class ProfileHelpPage extends StatefulWidget {
  @override
  _ProfileHelpPageState createState() => new _ProfileHelpPageState();
}

class _ProfileHelpPageState extends State<ProfileHelpPage> {
 
 

  @override
  Widget build(BuildContext context) {
   

    
        return new Scaffold(
          resizeToAvoidBottomInset: true,
            appBar: new AppBar(title: const Text('Profil et Paramètres'), 
             backgroundColor:  Color(0xFFFF5722),
              
           
            ),
         
            body: ListView(
            children :<Widget>[
              ExpansionTile(
    
      title: Text(
                          'Connexion et mot de passe',
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
                          '\n      Si vous connaissez votre mot de passe actuel,\n      vous pouvez le modifier en accèdant\n      à vos paramètres profil public.\n      Votre mot de passe ne doit pas correspondre\n      à votre adresse email, à votre numéro de\n      téléphone ni à votre date d’anniversaire.\n',


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
                          'Où puis-je accéder à mes paramètres ?',
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
                          '\n      Pour accéder à vos paramètres\n      1-Cliquez sur l’icone  en haut de votre page\n      d’acceuil \n      2-Dans cette liste vous trouverez un bouton\n      "Paramères du compte"\n      3-Cliquez sur\n',


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
                          'Comment modifier les informations générales de mon profil  ?',
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
                          '\n  Pour modifier vos informations\n  1-Accèdez à vos paramètres\n  2-Cliquez sur le bouton "Modifier"\n  Dans cette section vous pouvez modifier\n  votre nom, prénom, nom d’utilisateur...\n',


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
                          'Comment les noms et les identifiants d’utilisateur sont-ils utilisés ?',
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
                          '\n      Les noms et les identifiants d’utilisateur font\n      partie de votre profil public,\n      et vos amis peuvent s’en servir pour vous\n      trouver sur notre application.\n',


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