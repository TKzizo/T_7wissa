/*Page d'aide service assistance de l'application*/

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


class AssistanceHelpPage extends StatefulWidget {
  @override
  _AssistanceHelpPageState createState() => new _AssistanceHelpPageState();
}

class _AssistanceHelpPageState extends State<AssistanceHelpPage> {
  String _body=''; 
  

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
                          '\n    Dites-nous si vous avez des idées\n    susceptibles d’améliorer notre produit,\n    et si vous avez besoin d’aide pour résoudre\n    un problème spécifique.\n',
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
          onChanged: (val) {
                   
                  setState(() => _body = val);
                },
        
),

/*La possiblité de l'envoi d'un email aux dévellopeurs de l'application*/
  trailing:  IconButton(onPressed:() async {
      String platformResponse;
    try {
      Email email = Email(
        body: _body,
        subject: 'T7wissa',
        recipients: ['t7wissa.esi@gmail.com'],
        cc: ['id_berraoui@esi.dz'],
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
     },
     icon: Icon(Icons.send,color: Colors.greenAccent ),                 
    ),
       ),
             SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                       image: AssetImage('assets/EQUIPE.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
        ]
        ),       
        );
  }
}