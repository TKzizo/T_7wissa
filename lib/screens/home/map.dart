import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/services/creationGroupe.dart';

import 'modifierProfil.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _selectedItem = '';
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  // text field state
  String nom = '';
  String lieu = '';
  String error =''; 
  String heure ='';
  List<dynamic> listMembre = null;
  String admin = '';
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
   Position position;
String searchAddr;
double poslat;
double poslong; 





searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 12.0
          )

          ));
          poslat = result[0].position.latitude;
          poslong = result[0].position.longitude; 
    });
    
    
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.752887, 3.042048),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.deepOrange,
          center: latlng,
          fillColor: Colors.deepOrange.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }


  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }



/*COMPOSANTS*/ 
Widget _mapWidget(){
        return  Container(
          child: Scaffold(
           key: _scaffoldKey,
            backgroundColor: Colors.white,           
            body: GoogleMap(
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
              floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 500.0),
    child: FloatingActionButton(
        child: Icon(Icons.location_searching),
        mini: true,
        onPressed: () {
          getCurrentLocation();
        },
        backgroundColor: Colors.deepOrangeAccent,
        ),),
              /* floatingActionButton: FloatingActionButton(
                child: Icon(Icons.location_searching,),
                onPressed: () {
                  getCurrentLocation();
                },
                backgroundColor: Colors.deepOrangeAccent,
          ),*/
       )               
        );  
    
  }

  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
      BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );
    return Scaffold(

      /*Bar*/
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0.0,
        title: Text('Acceuil'),
        

      )  ,
      /*MENU*/
        bottomNavigationBar: BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.free_breakfast ), color:Colors.teal[600], onPressed: () => _onBreakButtonPressed(),),
          IconButton(icon: Icon(Icons.message), color:Colors.teal[600], onPressed: ()=> _onMessageButtonPressed(),),
          IconButton(icon: Icon(Icons.group ),  color:Colors.teal[600],onPressed: () =>_onGroupButtonPressed(),),
          IconButton(icon: Icon(Icons.place),  color:Colors.teal[600],onPressed: () =>list_invitations(),),
        ],
      ),
    ),
      body:   SlidingUpPanel(
       backdropEnabled: true,
      panelBuilder: (ScrollController sc) => _scrollingmessagesList(sc),
     body: _mapWidget(),
      
       borderRadius: radius ,
      ),
     

      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height:250,
                width: 250,
                child: Image(
                  image: AssetImage('assets/avatar.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return  Text(
                          userData.identifiant);
                    }else{
                      return Text('Loading');
                    }
                  }
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(children: [
                ListTile(
                  leading: Icon(Icons.settings, color:Colors.teal[300], ),
                  title: Text('Paramètres du compte'),
                  onTap: () async {
                   _onParametrePressed();                },
                ),
                ListTile(
                  leading: Icon(Icons.info, color:Colors.teal[300], ),
                  title: Text("Aide"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share, color:Colors.teal[300], ),
                  title: Text("Partager l'application"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 12,),
                ListTile(
                  leading: Icon(Icons.done_outline,color:Colors.teal[300], ),
                  title: Text("Déconnexion"),
                  onTap: () async {
                    await _auth.signOut();
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );




  }
/*Messages  recues*/ 
_buildRecievedMessageslistItem(BuildContext ctx,DocumentSnapshot document) {
     return(ListTile(
    title: Text(
      document['sender']+":",
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
     subtitle :   Text(
                       document['message'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
         trailing:    Text(
                       document['time'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize:12.0
                      ),
                      textAlign: TextAlign.left                
                      ),




                      )
                  );
  }
  /*messages a envoyer*/ 
  Widget _scrollingmessagesList(ScrollController sc){
  return Container(
  padding: EdgeInsets.symmetric(vertical:20.0,horizontal:40.0),
  child:
  ListView(
    controller: sc,
    children: <Widget>[
   ListTile(
   title:  Text(
      'On a démarré !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.departure_board),
   trailing: Icon(Icons.send),

   ),
  ListTile(
   title:  Text(
      'Je suis en route !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.directions_car),
   trailing: Icon(Icons.send),

   ),
  ListTile(
   title:  Text(
      'Je suis arrivé !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.arrow_drop_down_circle),
   trailing: Icon(Icons.send),

   ),
  ListTile(
   title:  Text(
      'J ai besoin d aide',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.help),
   trailing: Icon(Icons.send),

   ),
  ListTile(
   title:  Text(
      'Je suis en panne ! !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.build),
   trailing: Icon(Icons.send),

   ),
   ListTile(
   title:  Text(
      'un accident !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   
   trailing: Icon(Icons.send),

   ),
   ListTile(
   title:  Text(
      'Route endomagée !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   
   trailing: Icon(Icons.send),

   ),
   ListTile(
   title:  Text(
      'Alerte barage !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   
   trailing: Icon(Icons.send),

   ),
   ListTile(
   title:  Text(
      'Alerte radar !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.flag),
   trailing: Icon(Icons.send),

   ),
   ListTile(
   title:  Text(
      'Appelez moi !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.call),
   trailing: Icon(Icons.send),

   ),
  ListTile(
   title:  Text(
      'OK!',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.check),
   trailing: FlatButton(
     child: Icon(
       Icons.send, 
     ),
     onPressed: (){}, ),

   ),
  
    ],
    
  ));
 
}
void _onMessageButtonPressed(){
   
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
      height: 535,
      child:Container(
      decoration: BoxDecoration(
       color: const Color(0xffffffff),
      borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(30) ,
          topRight:  const Radius.circular(30) ,
        ),
      ),
      
       child: Stack(children: [
  // ✏️ Headline 6 
  PositionedDirectional(
    top: 35,
    start: 38,
    child: 
        SizedBox(
      width: 77,
      height: 26,
      child: Text(
      "Messages ",
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
     child: StreamBuilder(
     stream: Firestore.instance.collection('messagerie').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("aucun message",
      style: const TextStyle(
      color:  const Color(0xff3d3d3d),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 17.0
  ),
  textAlign: TextAlign.left 
     
     
     );
   return  ListView.builder(
     itemExtent: 80.0,
     itemCount:snapshot.data.documents.length,
    itemBuilder: (ctx,index )=> (
    _buildRecievedMessageslistItem(ctx,snapshot.data.documents[index])),
      );
    
     }
         )
    
       
      ) , 
      
      ]
      )
         
          ),
        
          );
          
    
        }
        );
         
      }
/*Groupes*/
void _onGroupButtonPressed(){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
      height: 535,
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
      width: 77,
      height: 26,
      child: Text(
      "Groupes ",
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
     child: StreamBuilder(
     stream: Firestore.instance.collection('groupe').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("aucun groupe",
      style: const TextStyle(
      color:  const Color(0xff3d3d3d),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 17.0
  ),
  textAlign: TextAlign.left 
     
     
     );
   return  ListView.builder(
     itemExtent: 80.0,
     itemCount:snapshot.data.documents.length,
    itemBuilder: (ctx,index )=> (
    _buildlistItem(ctx,snapshot.data.documents[index])),
      );
    
     }
         
      )
    
       
      ) , 
       PositionedDirectional(
    top: 300,
    start: 275,
    child: 
        SizedBox(
      
      child:FloatingActionButton(onPressed:()=>creeGroupe(),
         child: Icon(Icons.add,
         size: 40,
         ),
         backgroundColor: const Color(0xffff5722),
         focusColor: Colors.white,
         ),
        ),
  ),
      
      ]
      )
         
          ),
        
          );
          
    
        }
        );
         
      }
     _buildlistItem(BuildContext ctx,DocumentSnapshot document) {
     return(ListTile(
    title:Row (
       
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children : <Widget>[
       Text(
      document['nom'],
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
      Spacer(flex:1,),
     Text(  "à : "+ document['destination'],
                      style: const TextStyle(
                          color:  const Color(0xff52bf90),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left              
                      ),]),
     subtitle :   Text(
                      "Admin : "+ document['admin'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
         trailing:    IconButton(onPressed:()=> _quittergroupe(document.documentID),
                         icon: Icon(
                        Icons.arrow_forward,
                         color:  const Color(0xffff5722),
                        ),
                      
                         ),
                         onTap:null, 
                      )   
                  );
                    }
                      _quittergroupe(docId) {
            Firestore.instance.collection('groupe').document(docId).delete().catchError((e){
              print(e);});
              print('supp');
            }
void creeGroupe(){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
        height: 600,
        child: Container(
        decoration: BoxDecoration(
       color: const Color(0xffffffff),
        borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(60) ,
          topRight:  const Radius.circular(60) ,
        ),
        ),
      child : Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
        child : Form(
          key : _formKey,
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0),
              TextFormField(
                decoration: const InputDecoration(
                 hintText: 'Nom du groupe',
                  ),
                validator: (val) => val.isEmpty ? 'Donner un nom ' : null,
                onChanged: (val) {
                  setState(() => nom = val);
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: const InputDecoration(
                 hintText: 'Distination',
                 suffixIcon: Icon (
                            Icons.search, 
                            color : Color(0xffff5722),
                        ),
                  ),
                validator: (val) => val.isEmpty  ? 'Choisissez une distination' : null,
                onChanged: (val) {
                  setState(() => lieu = val);
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: const InputDecoration(
                 hintText: 'Heure de deppart',
                  ),
                validator: (val) => val.isEmpty ? 'Donnez une heure de deppart' : null,
                onChanged: (val) {
                  setState(() => heure = val);
                },
              ),
              Row(
                 children: <Widget>[
                   SizedBox(height: 80,),
                   SizedBox(width: 100,),
                   FlatButton.icon(
                     icon: Icon(Icons.add_circle,color: Color(0xffff5722), size: 40,),
                     label: Text("Ajoutez les membres"),
                     onPressed: () => print(nom)
                    ),
                  ],      
              ),
              SizedBox(height: 20.0),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.deepOrange,
                child: 
                MaterialButton(
                minWidth: 174,
                height: 36,
                child: 
                Text("Crée le groupe",
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
                    CreationGroupeServises g = new CreationGroupeServises();
                    g.creerGroupe(admin, lieu, heure, listMembre, nom);
                  }
                }
              ),
              ), 
            ],
          ),
        ),
      ),
      )
     );
    }
    );
    
  }
    void _onInvitationConfirmationPressed(DocumentSnapshot document){
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
      "Vos invitations ",
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
                      onPressed: () {_refuserInvitation(document.documentID); Navigator.of(context).pop();}
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
      "Ajouter un point de repos ",
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
                      onPressed: () {Navigator.of(context).pop();}
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
  void _onBreakButtonPressed(){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
      height: 535,
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
      width: 10000,
      height: 26,
      child: Text(
      "Ajouter un point de repos ",
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
          key: _formKey,
          child: SingleChildScrollView(
            child:SingleChildScrollView(
                          child: Column(
                children: <Widget>[
                  SizedBox(height: 12,),
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
                          hintText: "Entrez une adresse ",
                         suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchandNavigate,
                        iconSize: 30.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                      ),
                      //Validation de l'entrée
                      validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                       onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                    
                  });
                },
                    ),
                  ),
           /*TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchandNavigate,
                        iconSize: 30.0)),
                onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                    
                  });
                },
              ),*/
                  SizedBox(height: 12,),
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
                          contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          hintText: "Heure",
                          suffixIcon: Icon (
                            Icons.timer,
                            color:  Colors.deepOrange,
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                      ),
                      //Validation de l'entrée
                      validator: (val) => val.isEmpty ? 'Entrez l''heure' : null,
                      onChanged: (val) {
                        String heure;
                      setState(() => heure= val);
                      },
                    ),
                  ),
                   SizedBox(height: 40.0),
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.deepOrange,
                    child:
                    MaterialButton(
                        minWidth: 174,
                        height: 36,
                        child:
                        Text("AJOUTER",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color:  const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                        ),
                        onPressed: ()=> _onBreakConfirmationPressed(),
                    ),
                  ),
                ],
              ),
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
void _onParametrePressed(){
    showModalBottomSheet(context: context, builder:(context){
      final user = Provider.of<User>(context);
     return Container(
        color: const Color(0xff737373),
       width: 360,
        height: 600,
        child: Container(
        decoration: BoxDecoration(
       color: const Color(0xffffffff),
        borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(60) ,
          topRight:  const Radius.circular(60) ,
        ),
        ),
      child: Stack(children: [
  PositionedDirectional(
    top: 35,
    start: 38,
    child: 
        SizedBox(
      width:360,
      height: 28,
      child: Text(
      "Paramètre du compte  ",
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
     child: StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("Loading",
      style: const TextStyle(
      color:  const Color(0xff3d3d3d),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 17.0
  ),
  textAlign: TextAlign.left 
     
     
     );
      UserData userData=snapshot.data;
   return  Column(
     
   children: <Widget>[
   SizedBox(
                height:250,
                width: 250,
                child: Image(
                  image: AssetImage('assets/avatar.png'),
                  fit: BoxFit.contain,
                ),
              ),
    
            
           ListView(children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(userData.nom +" " + userData.prenom,
                   style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left
                  
                  
                  
                  
                  ),
              
                ),
                
                 ListTile(
                  leading: Icon(Icons.phone, color: Colors.greenAccent,),
                  title: Text(userData.numtel,
                   style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left),
              
                ),
                ListTile(
                  leading: Icon(Icons.mail, color: Colors.greenAccent,),
                  title: Text(userData.identifiant,
                   style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left),
              
                ),

                


   ],
             

   ),
   
   ]

   );
   }
     )

                  
   ),
    const SizedBox(height: 30),
     PositionedDirectional(
    top: 300,
    start:100,
       child:  FlatButton(
          onPressed: () {

             Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileView()),
                      );
          },
          textColor: Colors.white,
         
          child: Container(
            decoration: const BoxDecoration(
               borderRadius:  BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFFFF5722),
                  Color(0xFFFF7043),
               
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Modifier le profil',
               style: const TextStyle(
                         
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left),
          ),
        ),
    )
      ]
   ),
   
   )
      
      );
      
      

    }
     );
}
void list_invitations(){
   showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: 360,
      height: 535,
      child:Container(
      decoration: BoxDecoration(
       color: const Color(0xffffffff),
      borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(60) ,
          topRight:  const Radius.circular(60) ,
        ),
      ),
      
       child: Stack(children: [
  // ✏️ Headline 6 
  PositionedDirectional(
    top: 35,
    start: 38,
    child: 
        SizedBox(
      width: 150,
      height: 50,
      child: Text(
      "Invitations",
      style: const TextStyle(
          color:  const Color(0xde204f6f),
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 25.0
      ),
      textAlign: TextAlign.left                
      ),
      
      ),
      
  ),
     
     Container( 
     padding: EdgeInsets.symmetric(vertical:65.0,horizontal :20.0),
     child: StreamBuilder(
     stream: Firestore.instance.collection('invitation').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("aucune invitation",
      style: const TextStyle(
      color:  const Color(0xff3d3d3d),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 17.0
  ),
  textAlign: TextAlign.left 
     
     
     );
   return  ListView.builder(
     
     itemExtent: 80.0,
     itemCount:snapshot.data.documents.length,
    itemBuilder: (ctx,index )=> (
    buildInvitationlistItem(ctx,snapshot.data.documents[index])),
      );
    
     }
         
      )

      ) , 
      ]
      )
         
          ),
        
          );
          
    
        }
        );
         
      }
     buildInvitationlistItem(BuildContext ctx,DocumentSnapshot document) {
     return(ListTile(
    title:Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children : <Widget>[
       Text(
      document['groupe'],
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 20.0
      ),
      textAlign: TextAlign.left                
      ),
      Spacer(flex:1,),
     Text(
                      "à : "+ document['destination'],
                      style: const TextStyle(
                          color:  const Color(0xff52bf90),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      //textAlign: TextAlign.left              
                      ),
                      IconButton(onPressed:()=> _onInvitationConfirmationPressed(document) /*_refuserInvitation(document.documentID)*/,
                         icon: Icon(
                        Icons.cancel,
                         color:  const Color(0xffff5722),
                         size: 30,
                        ),
                      
                         ),
                         IconButton(onPressed:()=>  _onInvitationConfirmationPressed(document),//a changer
                         icon: Icon(
                        Icons.check_circle,
                         color:  const Color(0xff13ef81),
                         size: 30,
                        ),
                      
                         )
                      ]
                      ),
     subtitle :   Text(
                      "Admin : "+ document['admin'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
                           onTap:null, /*_quittergroupe(document.documentID),*/
                      )
                  );
                    }//buildItem
                      _refuserInvitation(docId) {
            Firestore.instance.collection('invitation').document(docId).delete().catchError((e){
              print(e);});
              print('supp');

  }
}
