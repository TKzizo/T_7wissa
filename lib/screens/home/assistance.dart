import 'dart:async';

import 'package:flutter/material.dart';


class AssistanceHelpPage extends StatefulWidget {
  @override
  _AssistanceHelpPageState createState() => new _AssistanceHelpPageState();
}

class _AssistanceHelpPageState extends State<AssistanceHelpPage> {
 
 

  @override
  Widget build(BuildContext context) {
   

    
        return new Scaffold(
          resizeToAvoidBottomInset: true,
            appBar: new AppBar(title: const Text('Assistance'), 
             backgroundColor:  Color(0xFFFF5722),
              
           
            ),
         
            body: ListView(
            children :<Widget>[ ListTile(
    
      title: Text(
                          'Bienvenue !',
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
                          '\n    Dites-nous si vous avez des idées\n    susceptibles d’améliorer nos produits.\n    Et si vous avez besoin d’aide pour résoudre\n    un problème spécifique.\n',


                          style: const TextStyle(
                              color:  const Color(0xde3d3d3d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left                
                          ),
      ),
       ListTile(
         title : new TextField(
  keyboardType: TextInputType.multiline,
  maxLength: null,
  maxLines: null,
),
       )
            


        ]




        ),
        
       
        );
  }
}