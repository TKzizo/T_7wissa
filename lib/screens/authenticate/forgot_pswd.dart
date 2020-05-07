import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';

class Forgotpswd extends StatefulWidget {


  @override
  _ForgotpswdState createState() => _ForgotpswdState();
}

class _ForgotpswdState extends State<Forgotpswd> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  
 /* Mot de passe */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0.0,
        title: Text('Réinitialisation du mot de passe ',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
                      fontFamily: "Roboto-light",
                      fontStyle:  FontStyle.normal,
                      fontSize: 17.0,    
            ), 
        ),     
      ),
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
              /*lOGO*/ 
                SizedBox(
                      height: 225,
                      width: 159,
                      child: Image(
                       image: AssetImage('assets/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
              Material(
                
                child: SizedBox(
                      height: 25,
                      
                      child: Text('Entrez votre email',
                        textAlign: TextAlign.left,
                      ),
                    ),
              ), 
               

              SizedBox(height: 0.0),
              /*Champs Email*/ 
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
                        hintText: "Entrez votre email",
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
            /*ENVOIE*/ 
              SizedBox(height: 30.0),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.deepOrange,
                child: 
                MaterialButton(
                minWidth: 174,
                height: 36,
                child: 
                Text("ENVOYER",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color:  const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),
                ),
                onPressed: ()=>_onBreakConfirmationPressed(),
              ),
              ), 
         
            ],
          ),

          ), 

        ),
      ),
    );
  }
  void _onBreakConfirmationPressed(){
      showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
      height: 240,
      child:Container(
      decoration: BoxDecoration(
       color: const Color(0xffffffff),
      borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(30) ,
          topRight:  const Radius.circular(30) ,
        ),
      ),
      
       child: Stack(children: [
  PositionedDirectional(
    top: 35,
    start: 38,
    child: 
        SizedBox(
      width: 1000,
      height: 26,
      child: Text(
      "Changer votre mot de passe",
      style: const TextStyle(
          color:  const Color(0xde204f6f),
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 19.0
      ),
      textAlign: TextAlign.left                
      )),
  ),
     
     Container( 
     padding: EdgeInsets.symmetric(vertical:65.0,horizontal :20.0),
     child:Form(
     
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,), 
                Text('Voulez vous confirmer ? ',
                textAlign: TextAlign.center,
                        style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 19.0
                        ),),
                 SizedBox(height: 10.0),
                Row(children: <Widget>[
                  SizedBox(width: 20,),
                   Material( borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child:

                  MaterialButton(
                      minWidth: 100,
                      height: 36,
                      child:
                      Text("OUI",
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
                     dynamic result = await _auth.resetPassword(email);
                    if(result == null) {
                      setState(() {
                        error = 'Vérifiez vos identifiants';
                      });
                    }else{
                      print('Email envoyé'); 
                    }
                   }}
                  ),
                ),
                SizedBox(width: 65,height: 70,),
                      Material( borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child:
                  MaterialButton(
                      minWidth: 100,
                      height: 36,
                      child:
                      Text("NON",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color:  const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        ),
                      ),
                      onPressed: () {Navigator.of(context).pop();}
                  ),
                ),
                ],),
            
              ],
            ),
          ),
       
      ))
       
      
      ]
      )
         
          ),
        
          );
          
    
        }
        );
         
  }
}