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
      body: Container(

        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250,
                  width: 159,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 50.0),
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
                    //Validation de l'entrée
                    validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),

                /*Champs Mot de passe*/
                SizedBox(height: 20.0),
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
                    //Validation de l'entrée
                    validator: (val) => val.length < 6 ? 'Mot de passe érroné' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  /*Champs Mot de passe*/
                ),


                /*Mot de passe oublié*/
                SizedBox(height: 30),
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
                  ),
                ),

                /*Mot de passe oublié*/

                /*CONNEXION*/
                SizedBox(height: 50.0),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child:
                  MaterialButton(
                      minWidth: 174,
                      height: 36,
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
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Pas encore membre,",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: const Color(0xde3d3d3d),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 15.0
                        ),
                      ), onPressed: () {},
                    ),
                    FlatButton(
                      child:
                      Text("Inscivez-vous",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: const Color(0xff00838f),
                            fontFamily: "Roboto-light",
                            fontStyle:  FontStyle.normal,
                            fontSize: 17.0
                        ),
                      ),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
                SizedBox(height: 11),


                /*Mot de passe oublié*/
                //Message d'erreur à la connexion
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 0),
                _signInButton(),
              ],
            ),

          ),

        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await googleSignIn.signInWithGoogle(); {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return GMap();
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
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
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