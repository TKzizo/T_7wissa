import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';

class RegisterForm extends StatefulWidget {

  final Function toggleView;
  RegisterForm({ this.toggleView });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // text field state
  String nom= '';
  String prenom = '';
  String utilisateur = '';
  String error ='';
  String phoneNumber;
String phoneIsoCode;

void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
} 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    
      
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        
        child: Form(
          key : _formKey, //associer formkey à form
        child: SingleChildScrollView(
          
          child: Column(
            children: <Widget>[
             SizedBox(height: 130),
         ButtonBar(
            alignment:MainAxisAlignment.center,

          children: <Widget>[
            
          Material(
             elevation: 4,
              borderRadius: BorderRadius.circular(30.0),
             child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                    height: 53,
                    width: 53,
                    child: RaisedButton(
                        child: Text('1', 
                        style: const TextStyle(
                     color:  const Color(0xff26a69a),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),),
                           
                            shape: StadiumBorder(side: BorderSide(color:  const Color(0xff26a69a))),
                            color: Colors.white,
                                onPressed: () {},
                            ),
                        ),
                    ),
          ),
          SizedBox(width: 20,), 
          Material(
             elevation: 4,
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.red,  
             child: FittedBox(
                fit: BoxFit.scaleDown,
                
                child: SizedBox(
                    height: 53,
                    width: 53,
                    child: RaisedButton(
                  
                        child: Text('2', 
                        style: const TextStyle(
                     color:  const Color(0xff26a69a),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),),                  
                            shape: StadiumBorder(side: BorderSide(color:  const Color(0xff9e9e9e),)),
                            color: Colors.white,
                                onPressed: () {},
                            ),
                        ),
                    ),
          ),
          SizedBox(width: 20,), 
          Material(
             elevation: 4,
              borderRadius: BorderRadius.circular(30.0),
             child: FittedBox(
                fit: BoxFit.scaleDown,
                
                child: SizedBox(
                    height: 53,
                    width: 53,
                    child: RaisedButton(
                        child: Text('3', 
                        style: const TextStyle(
                     color:  const Color(0xff26a69a),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),),
                           
                            shape: StadiumBorder(side: BorderSide(color:  const Color(0xff9e9e9e),)),
                            color: Colors.white,
                                onPressed: () {},
                            ),
                        ),
                    ),
          ),
             ], ), 
             /*Champs nom*/ 
             SizedBox(height: 76),
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child: 
                TextFormField(
                  
                    obscureText: false,
                    //TEXT 
                   style: TextStyle(
                      color:  Colors.grey[900], 
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                    ), 
                    //SHAPE
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Nom",

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre nom' : null,
                  onChanged: (val) {
                  setState(() => nom = val);
                },
              ),
              ), 
            /*Champs Email*/ 
              SizedBox(height: 12.0),
            /*Champs nom*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child: 
                TextFormField(
                  
                    obscureText: false,
                    //TEXT 
                   style: TextStyle(
                      color:  Colors.grey[900], 
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                    ), 
                    //SHAPE
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Prénom",

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre prénom' : null,
                  onChanged: (val) {
                  setState(() => prenom = val);
                },
              ),
              ), 
            /*Champs Email*/ 
            SizedBox(height: 12),
            /*Champs Nom utilisateur*/ 
                Material(
                  
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child: 
                TextFormField(
                   
                    obscureText: false,
                    //TEXT 
                   style: TextStyle(
                      color:  Colors.grey[900], 
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                    ), 
                    //SHAPE
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Nom utilisateur",

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre nom' : null,
                  onChanged: (val) {
                  setState(() => utilisateur = val);
                },
              ),
              ),
            /*Champs Nom utilisateur*/ 

              SizedBox(height: 70.0),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.deepOrange,
                child: 
                MaterialButton(
                minWidth: 174,
                height: 36,
                child: 
                Text("SUIVANT",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color:  const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    
                  }
                }
              ),
              ), 
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color : Colors.red, fontSize: 14.0 ),
              )
            ],
          ),
        ),
          
        ),
      ),
    );
  }
}