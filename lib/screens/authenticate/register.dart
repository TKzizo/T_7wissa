import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // text field state
  String email = '';
  String password = '';
  String error =''; 
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
           //   color: Colors.red,  
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
                      
                    child: Icon(
                    Icons.check,
                    size: 24,
                    color: const Color(0xff26a69a),
                   ),                   
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
                           
                            shape: StadiumBorder(side: BorderSide(color:  const Color(0xff26a69a))),
                            color: Colors.white,
                                onPressed: () {},
                            ),
                        ),
                    ),
          ),
             ], ), 
             /*Champs Email*/ 
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
                        hintText: "Email",
                        suffixIcon: Icon (
                          Icons.email, 
                          color:  Colors.teal[800],
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                  onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              ), 
            /*Champs Email*/ 
              SizedBox(height: 12.0),
            /*Champs Mot de passe*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                 color: Colors.white,
                child : 
                 TextFormField(
                obscureText: true,
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
                        hintText: "Mot de passe",
                        suffixIcon: Icon (
                            Icons.remove_red_eye, 
                            color:  Colors.teal[800],
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), )
                  ),
                  //Validation de l'entrée
                controller: _pass,
                validator: (val) => val.length < 6 ? 'Mot de passe invalide' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              ),
            /*Champs Mot de passe*/
            SizedBox(height: 12),
            /*Champs Confirmation Mot de passe*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child : 
                 TextFormField(
                obscureText: true,
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
                        hintText: "Confirmez le mot de passe",
                        suffixIcon: Icon (
                            Icons.remove_red_eye, 
                            color:  Colors.teal[800],
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: _confirmPass,
                  //Validation de l'entrée
                  validator: (val){
                              if(val.isEmpty)
                                   return 'Empty';
                              if(val != _pass.text)
                                   return 'Not Match';
                              return null;
                              }, 
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              ),
            /*Champs Confirmation Mot de passe*/ 

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
                   // dynamic result = await _auth.registerWithEmailAndPassword(email, password);   
                    //if(result==null){
                  //      setState(()=> error = 'Entrez un e-mail valide' );
                   // }
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