/*Page de Connexion*/

import 'package:flutter/material.dart';
import 'package:myapp/screens/authenticate/forgot_pswd.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/screens/home/map.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final AuthService googleSignIn = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height) * 0.063, horizontal: (MediaQuery.of(context).size.width) * 0.05),
        child : SingleChildScrollView(
        child: Form(
          key: _formKey,
          
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: (MediaQuery.of(context).size.height) * 0.4,
                  width: (MediaQuery.of(context).size.width) * 0.4,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                /*Champs Email*/
                Material(
                  elevation: 6.5,
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    /*Validation de l'entrée*/
                    validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),

                /*Champs Mot de passe*/
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.02,),
                Material(
                  elevation: 6.5,
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
                        hintText: "Mot de passe",
                        suffixIcon: Icon (
                          Icons.vpn_key,
                          color:  Colors.teal[800],
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    /*Validation de l'entrée*/
                    validator: (val) => val.length < 6 ? 'Mot de passe érroné' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  /*Champs Mot de passe*/
                ),


                /*Mot de passe oublié*/
                SizedBox(height:(MediaQuery.of(context).size.height) * 0.01,),
                Material(
                  child: FlatButton(
                    child:
                    Text("Mot de passe oublié ?",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: const Color(0xff7966ff),
                          fontFamily: "Roboto-light",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgotpswd()),
                      );
                    },
                    color:  const Color(0xffffffff),
                    disabledColor:const Color(0xffffffff) ,
                    hoverColor: const Color(0xffffffff),
                    splashColor: const Color(0xffffffff),
                  ),
                ),
                /*Mot de passe oublié*/

                /*CONNEXION*/
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.03,),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child:
                  MaterialButton(
                      minWidth:(MediaQuery.of(context).size.width) * 0.5,
                      height:(MediaQuery.of(context).size.height) * 0.036,
                      child:
                      Text("CONNEXION",
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
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if(result == null) {
                            setState(() {
                              error = 'Vérifiez vos identifiants';
                            });
                          }
                        }
                      }
                  ),
                ),
                /*CONNEXION*/

                /*Mot de passe oublié*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                     Text("            Pas encore membre,",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: const Color(0xde3d3d3d),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 15.0
                        ),
                      ), 
                    FlatButton(
                      child:
                      Text("Inscivez-vous",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: const Color(0xff00838f),
                            fontFamily: "Roboto-light",
                            fontStyle:  FontStyle.normal,
                            fontSize: 15.0
                        ),
                      ),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.023,),
                /*Mot de passe oublié*/

                /*Message d'erreur à la connexion*/   
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 0),
                _signInButton(),
              ],
            ),
        ),),
      ),
    );
  }

/* Bouton de connexion Google*/
  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await googleSignIn.signInWithGoogle(); {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MyHomePage();
              },
            ),
          );
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: (MediaQuery.of(context).size.height) * 0.025,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Connexion avec Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}