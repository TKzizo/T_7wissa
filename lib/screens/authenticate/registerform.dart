import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/screens/authenticate/register.dart';



class RegisterForm extends StatefulWidget {

  final Function toggleView;
  RegisterForm({ this.toggleView });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

  @override
  Widget build(BuildContext context) {
    return null;
  }
class _RegisterFormState extends State<RegisterForm> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // Champs du fomulaire (infomations relatives à un nouveau utilisateurs) 
  String nom= '';
  String email= '';
  String password='';
  String prenom = '';
  String utilisateur = '';
  String phoneNumber;

  int _currentStep=0; //Controle du steper 
  String error ='';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('Inscription',
          style: TextStyle(
            color:  Colors.black,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 17.0, ),
            ), 
        ),
      
     body: Center(
       widthFactor: 35,
       child: Form(
          key: _formKey,
          child: Stepper(
              type: StepperType.horizontal,
                steps: _mySteps(),
                controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                                Material(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.deepOrange,
                                    child: 
                                    MaterialButton(
                                    minWidth:125,
                                    height: 1.2,
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
                                    onPressed: onStepContinue,
                                  ),
                                  ),
                              SizedBox(width: 12,),
                              Material(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.grey[350],
                                child:  MaterialButton(
                                    minWidth:125,
                                    height: 1.2,
                                    child: 
                                    Text("ANNULER",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color:  const Color(0xffffffff),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto",
                                          fontStyle:  FontStyle.normal,
                                          fontSize: 16.0
                                      ),
                                    ),
                                  onPressed: onStepCancel,  
                                  ),
                              ),
                          ],
                        );
      },
         currentStep: this._currentStep,
         onStepTapped: (step){
           setState(() {
             this._currentStep= step; 
           });
         },
         onStepContinue: (){
           setState(() {
             if(_formKey.currentState.validate() && _currentStep < _mySteps().length-1)
              this._currentStep=this._currentStep+1; 
              else{
                  setState(()=> error = 'Oups il faut tout remplir ! ' );

              if(this._currentStep==_mySteps().length) 
                print('On envoie un email'); 
                dynamic result =  _auth.registerWithEmailAndPassword(email, password,nom,prenom,utilisateur,phoneNumber);
              }
           });
         },
         onStepCancel: (){
           setState(() {
              if(this._currentStep >0 )
             this._currentStep=this._currentStep-1; 
             else
               this._currentStep=0; 
           });
         }, ), ), ),);
  }
  List<Step> _mySteps(){
    List<Step> _steps= [
      Step(
        title: Text('Etape 1 '),
        content:Column(children: <Widget>[
          /*Champs Nom*/ 
          SizedBox(height: 50) ,
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
            
              SizedBox(height: 12),
              /*Champs Prenom*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child: 
                TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.text,
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
                        hintText: "Prenom",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre prénom' : null,
                  onChanged: (val) {
                  setState(() => prenom = val);
                },
              ),
              ), 
                 SizedBox(height: 12),
              /*Champs Numtle*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                child: 
                TextFormField(
                    obscureText: false,
                   keyboardType: TextInputType.emailAddress,

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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                  onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              ), 
                 SizedBox(height: 12),
              /*Champs Numtle*/ 
              Material(
                elevation: 4,
                 borderRadius: BorderRadius.circular(30.0),
                 
                child: 
                TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.phone,
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
                        hintText: "Numéro de téléphone",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez votre numéro de téléphone' : null,
                  onChanged: (val) {
                  setState(() => phoneNumber = val);
                },
              ),
              ),
              SizedBox(height: 20,), 
        ],), 
        isActive: _currentStep >=0, 
        state: _getState(1), ),
        Step(
        title: Text('Etape 2'),
        content:Column(children: <Widget>[
           /*Champs nom d'utilisateur*/ 
             SizedBox(height: 50),
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
                        hintText: "Nom d'utilisateur",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  //Validation de l'entrée 
                  validator: (val) => val.isEmpty ? 'Entrez un nom d''utilisateur'  : null,
                  onChanged: (val) {
                  setState(() => utilisateur = val);
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
        
          SizedBox(height: 72,),
          ],),
          state: _getState(2),
        isActive: _currentStep >=1, 
         
        ),
        Step(
        title: Text('Etape 3 '),
          content:Column(children: <Widget>[
              Text('Un mail de confirmation vous a été envoyé ! ',
              textAlign: TextAlign.center,
              style: TextStyle(
                    color:  Colors.grey[900], 
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 19.0
               ),),
              SizedBox(
                      height: 250,
                      width: 250,
                      child: Image(
                       image: AssetImage('assets/icone.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                              SizedBox(height: 0,),

          ],
          ),
      
        isActive: _currentStep >=2,  ),
    ]; 
    return _steps; 
  }
  StepState _getState(int i) {
    if (_currentStep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }
}