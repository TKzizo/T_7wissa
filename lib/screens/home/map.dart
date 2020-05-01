import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/screens/home/camera.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:myapp/services/creationGroupe.dart';
import 'package:myapp/services/chat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'modifierProfil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/services/Usersearch.dart'; 

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;
    Set<Marker> markers = Set();
    LatLng centerPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _selectedItem = '';
  int _cle; 
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  // text field state
  String nom = '';
  String lieu = '';
  String error =''; 
  String heure ='';
  String _current_user; 
  String _current_userId; 
String _time = "Not set";
  Random random = new Random();
  List<dynamic> listMembre = null;
  String _admin = '';
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  Position position;
  String searchAddr;
  double vitesse;
String text; 
FirebaseUser currentUser;
Widget _child; 
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyAZRocDA5-kIiOwosJclZ1WEO5BYB2oPmo");
   BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    setCustomMapPin();

    getPermission();
    super.initState();
    _loadCurrentUser();

  }
void setCustomMapPin() async {
      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size:Size(-12,-12)),
      'assets/jesuisenpanne.png');
   }
  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
        print(user.uid); 
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }
    Future<void> getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if(permission == PermissionStatus.denied){
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch(geolocationStatus){
      case GeolocationStatus.denied:
        showToast('Acess denied');
        break;
      case GeolocationStatus.disabled:
        showToast('Disabled');
        break;
      case GeolocationStatus.restricted:
        showToast('Restricted');
        break;
      case GeolocationStatus.unknown:
        showToast('Unknown');
        break;
      case GeolocationStatus.granted:
        showToast('Access Granted');
        _getCurrentLocation(_current_userId);
    }

  }
   void _getCurrentLocation(String userId) async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      vitesse = position.speed; 
       _child = _mapWidget();
    }
    );
    }
    List<Marker> allMarkers = []; 

/*void setMarkersfromFirebase(){
   print("SETTING MARKERS"); 
  StreamBuilder(
   
      stream: Firestore.instance.collection('groupe').document('1314').collection('Markers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading maps.. Please Wait');
        for (int i = 0; i < snapshot.data.documents.length; i++) {
          print(snapshot.data.documents.length); 
          //Text((contenu==null)?" ":contenu)
          print("ICI"); 
          print((snapshot.data.documents[i]['position'].longitude).toString() ==null ?" ": (snapshot.data.documents[i]['position'].longitude).toString() );
         /* allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['postion'].latitude).toDouble(),
                 (snapshot.data.documents[i]['position'].longitude).toDouble()),
                   markerId: snapshot.data.document[i]['user_id'],
                   icon:BitmapDescriptor.defaultMarkerWithHue
                  (BitmapDescriptor.hueViolet),
              ));*/ 
        }  
      },
    );
}*/
 Widget _mapWidget() {
    return StreamBuilder(
      stream: Firestore.instance.collection('groupe').document('1314').collection('Markers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading maps.. Please Wait');
        for (int i = 0; i < snapshot.data.documents.length; i++) {
         allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                  infoWindow: InfoWindow(
                        title: (snapshot.data.documents[i]['text']).toString() ==null ?"Alerte ! ": (snapshot.data.documents[i]['text']).toString(),
                        snippet:  (snapshot.data.documents[i]['sender']).toString() ==null ?"User! ": (snapshot.data.documents[i]['sender']).toString(),
                        onTap:  ()=> _markerPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?null: (snapshot.data.documents[i]['senderId']).toString()),

                    ),
                  
              ));
    
        
        }
      /*MAP*/ 
      allMarkers.add(
       new      Marker(
        markerId: MarkerId('home'),
        position: LatLng(position.latitude,position.longitude),
        infoWindow: InfoWindow(title: 'position actuelle'), 
        icon:pinLocationIcon, 
        )
         
    );
        return    GoogleMap(
          
                  markers: Set.from(allMarkers),
                  initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude,position.longitude),
          
          zoom: 12.0
      ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                );   
      },
    );
  }
   void _markerPressed(String userId){
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
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid:userId).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return    Container( 
     padding: EdgeInsets.symmetric(vertical:65.0,horizontal :20.0),
      child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,), 
                Row(
                  children: <Widget>[
                    Text('Nom ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                              Text(userData.nom,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                  ],
                ),
                 SizedBox(height: 20,), 
                Row(
                  children: <Widget>[
                    Text('Prenom',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                              Text(userData.prenom,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                  ],
                ),                
                 SizedBox(height: 20,), 
                Row(
                  children: <Widget>[
                    Text('Identifiant ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                              Text(userData.identifiant,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                  ],
                ),
              ],
            ),
          ),
       
      );
                    }else{
                      return Text('Loading');
                    }
                  }
              ),
       
      
      ]
      )
         
          ),
        
          );
          
    
        }
        );
         
  }
   void showToast(message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
/*METHODES RECHERCHES ET AUTOCOMPLETE*/ 
Future<Null> displayPrediction(Prediction p) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: 
           LatLng(lat, lng),
           zoom: 16.0
    )));
  }
}

Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyAZRocDA5-kIiOwosJclZ1WEO5BYB2oPmo",
      language: "fr",
      components: [Component(Component.country, "dz")],
    );
   
    displayPrediction(p);
  }
/*METHODES RECHERCHES ET AUTOCOMPLETE*/ 

 //createur de marker 
 /* setMarkers() {
    allMarkers.add(
       new      Marker(
        markerId: MarkerId('home'),
        position: LatLng(position.latitude,position.longitude),
        infoWindow: InfoWindow(title: 'position actuelle')
        )
         
    );
    return allMarkers;
  }*/
  //
Marker marqer=Marker(markerId: MarkerId("Current"),
position: LatLng(17.385044, 78.486671),);


/*Marker marker1=Marker(markerId:MarkerId("1"), 
position: LatLng(36.741285, 3.172218), 
  );*/

Marker marker2= new Marker(markerId: MarkerId("2"),
position: LatLng(45.393102, 12.353055),
//icon: myIcon,

 icon: BitmapDescriptor.defaultMarkerWithHue
(BitmapDescriptor.hueViolet));



Marker marker3=Marker(markerId: MarkerId("3"),
position: LatLng(36.732021, 3.172555),
 icon:BitmapDescriptor.defaultMarkerWithHue
(BitmapDescriptor.hueGreen),
 );

 


/*COMPOSANTS*/ 


/*Widget _mapWidget(){
allMarkers.add(
       new      Marker(
        markerId: MarkerId('home'),
        position: LatLng(position.latitude,position.longitude),
        infoWindow: InfoWindow(title: 'position actuelle'), 
        icon:pinLocationIcon, 
        )
         
    );
   // allMarkers.add(marker1); 
      allMarkers.add(marker2);
      allMarkers.add(marker3); 
        return    GoogleMap(
                  markers: Set.from(allMarkers),
                  initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude,position.longitude),
          
          zoom: 12.0
      ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                );   
          }  */              
        
 
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
      bottomNavigationBar:   BottomAppBar(
          color: Colors.white.withOpacity(0.5),

      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*IconButton(icon: Icon(Icons.free_breakfast), onPressed: () => _onBreakButtonPressed(),),
          IconButton(icon: Icon(Icons.message), onPressed: ()=> _onMessageButtonPressed(),),
          IconButton(icon: Icon(Icons.group ), onPressed: () =>_onGroupButtonPressed(),),
          IconButton(icon: Icon(Icons.place), onPressed: () {},),*/
           Container(
                     width: 40.0,
                     height: 40.0,
                      child: FloatingActionButton(
                      onPressed: () => _onBreakButtonPressed(),
                      child: Icon(
                       Icons.free_breakfast,
                      size: 25.0,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
         
            Container(
                     width: 40.0,
                     height: 40.0,
                      child: FloatingActionButton(
                      onPressed: ()=> _onMessageButtonPressed(),
                      child: Icon(
                       Icons.email,
                      size: 25.0,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
            
              Container(
                     width: 40.0,
                     height: 40.0,
                      child: FloatingActionButton(
                      onPressed:() =>_onGroupButtonPressed(),
                      child: Icon(
                       Icons.group,
                      size: 25.0,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
           
              Container(
                     width: 40.0,
                     height: 40.0,
                      child: FloatingActionButton(
                      onPressed: () =>_onMembreButtonPressed(),
                      child: Icon(
                       Icons.view_list,
                      size: 25.0,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
                    Container(
                     width: 40.0,
                     height: 40.0,
                      child: FloatingActionButton(
                      onPressed: () {
                        list_invitations(context, _current_userId); 
                      },
                      child: Icon(
                       Icons.place,
                      size: 25.0,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
                  
        ],
      ),
    ),
        
      body:   SlidingUpPanel(
       backdropEnabled: true,
      panelBuilder: (ScrollController sc) => _scrollingmessagesList(sc),
      body: _child,
      
       borderRadius: radius ,
       minHeight: 12,
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
                  leading: Icon(Icons.settings, color: Colors.greenAccent,),
                  title: Text('Paramètres du compte'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _onParametrePressed();

                  },
                ),
                ListTile(
                  leading: Icon(Icons.info,color: Colors.greenAccent, ),
                  title: Text("Aide"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              
                ListTile(
                  leading: Icon(Icons.share,color: Colors.greenAccent,),
                  title: Text("Partager l'application"),
                  onTap: () {
                    Share.share('LINK TO OUR APP IN PLAY STORE ');
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 12,),
                ListTile(
                  leading: Icon(Icons.done_outline, color: Colors.greenAccent,),
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
  _refuserInvitation(docId,userID) {
              Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').document(docId).delete().catchError((e){
              print(e);});
              

            }

    _accepterInvitation(docId,grpID,userID) {

            //ajouter l'utilisateur dans la liste des membres du groupe
     Firestore.instance.collection('groupe').document(grpID).collection('ListeMembre').document().setData({
              'id' : userID,
            }).catchError((e){print(e);});       
            //ajouter le groupe dans la liste des groupes de l'utilistateur
            Firestore.instance.collection('utilisateur').document(userID).collection('ListeGroupe').document().setData({
              'id' : grpID,
            }).catchError((e){print(e);});
            //supprimer l'invitation
            Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').document(docId).delete().catchError((e){
              print(e);});
            
          }

  void _onAddMarkerButtonPressed() {
    InfoWindow infoWindow =
    InfoWindow(title: "Location" + markers.length.toString());
    Marker marker = Marker(
      markerId: MarkerId(markers.length.toString()),
      infoWindow: infoWindow,
      position: centerPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    setState(() {
      markers.add(marker);
    });
  }
/*Messages  recues*/ 
/*Messages  recues*/ 
_buildRecievedMessageslistItem(BuildContext ctx,DocumentSnapshot document) {
      if ((document['image'])!=null ){
        
     return(ListTile(
       
    title: Image.network(document['image']),
    

      
     subtitle :   Text(
                       document['sender'].toString(),
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
                  );}
                  else{
                    return(ListTile(
       
    title: Text(
                       document['text'].toString(),
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
     

      
     subtitle :   Text(
                       document['sender'].toString(),
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
   leading: Icon(Icons.departure_board,color: Color(0xFFFF5722),),
   trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','On a démarré!', _current_user,_current_userId,null);
     },
     icon: Icon(
                        Icons.send,
                        color: Colors.greenAccent
                        ),
                      
                         ), 

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
   leading: Icon(Icons.directions_car,color: Color(0xFFFF5722),),
    trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Je suis en route !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.arrow_drop_down_circle,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Je suis arrivé(e)', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.help,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','J''ai besoin d''aide ! ', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.build,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {  
    CreationGroupeServises(uid: _cle.toString()).marquer_Alerte('1314', "je suis en panne !", position.longitude, position.latitude, _current_userId, "image");
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Je suis en panne ! ', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.flash_on,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
    CreationGroupeServises(uid: _cle.toString()).marquer_Alerte('1314', "Un accident!", position.longitude, position.latitude, _current_userId, "image");
     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Un accident !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.blur_off,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {     
 //  Future marquer_Alerte(String id, String text,Position position, String senderId, String icon ) async{

     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Route endommagée ! ', _current_user,_current_userId,null);
    CreationGroupeServises(uid: _cle.toString()).marquer_Alerte('1314', "Route endommagée  !", position.longitude, position.latitude, _current_userId, "image");

     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.flag,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
    CreationGroupeServises(uid: _cle.toString()).marquer_Alerte('1314', "Alerte barrage !", position.longitude, position.latitude, _current_userId, "image");

     ChatService(uid: _cle.toString() ).envoyer_mesg(/*_cle.toString()*/'1314','Alerte Barage ! ', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   
   leading: Icon(Icons.router,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
    CreationGroupeServises(uid: _cle.toString()).marquer_Alerte('1314', "Alerte radar!", position.longitude, position.latitude, _current_userId, "image");
     ChatService(uid: _cle.toString() ).envoyer_mesg(_cle.toString(),'Alerte radar !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
   leading: Icon(Icons.call,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(_cle.toString(),'Appelez moi  !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
   ),
 
    ListTile(
   title:  Text(
      'OK !',
      style: const TextStyle(
          color:  const Color(0xff3d3d3d),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
   leading: Icon(Icons.check,color: Color(0xFFFF5722),),
 trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(_cle.toString(),'OK  !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
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
      width: 100,
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
     stream: Firestore.instance.collection('chat').document('1314').collection('messages').snapshots(),
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
       PositionedDirectional(
    top: 270,
    start:20,
       child: SizedBox(
      width:300,
      height: 50,
      child:
       
       ListTile(
   title:  TextField(
     decoration: InputDecoration(
       hintText: "Envoyer..",
                       suffixIcon : IconButton(icon:Icon(Icons.camera_alt,color: Colors.greenAccent),onPressed:()async{
    
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ImageCapture()),
                      );})),
                 onChanged: (val) {
                   
                  setState(() => text = val);
                },
                       
  ), 
trailing:  IconButton(onPressed:() async {      
     ChatService(uid: _cle.toString() ).envoyer_mesg(_cle.toString(),text, _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent ),
                      
    ),
   ), 
       )), ]
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
      width: 150,
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
                      autofocus: false,
                      cursorColor: Colors.deepOrange,
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
                          hintText: "Entrez une adresse ",
                         suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: Colors.deepOrange,),
                        onPressed:
                          _handlePressButton,
                        
                        iconSize: 30.0),
                      ),
                      //Validation de l'entrée
                      validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                       onChanged: (val) {
                  setState(() {
                    lieu = val;
                    
                  });
                },
                    ),
              SizedBox(height: 15.0),
              /*Heure de depart*/ 
               Material(
                    elevation: 2.5,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    shadowColor: Colors.white,
                     child: FlatButton(
                       focusColor: Colors.white,
                       highlightColor: Colors.white,
                     onPressed: () {
                    DatePicker.showTimePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (time) {
                      print('confirm $time');
                      
                      _time = '${time.hour} : ${time.minute} : ${time.second}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                    setState(() {});
                }, 
                child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                
                                  Text(
                                    " $_time",
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                         Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.deepOrange,
                                  ),
                      ],
                    ),
                ),
                color: Colors.white,
              ),
                  ), 
                  /*HEURE DE DEPART */
           
              Row(
                 children: <Widget>[
                   SizedBox(height: 80,),
                   SizedBox(width: 100,),
                   FlatButton.icon(
                     icon: Icon(Icons.add_circle,color: Color(0xffff5722), size: 40,),
                     label: Text("Ajoutez les membres"),
                     onPressed: () => showSearch(context: context, delegate: UserSeach())
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
                    int _id = random.nextInt(10000);
                     _cle = _id; 
                    CreationGroupeServises(uid: _id.toString() ).creerGroupe(_admin, lieu, _time, listMembre, nom);
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
                
                    TextFormField(
                      autofocus: false,
                      cursorColor: Colors.deepOrange,
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
                          hintText: "Entrez une adresse ",
                         suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: Colors.deepOrange,),
                        onPressed:
                          _handlePressButton,
                        
                        iconSize: 30.0),
                      ),
                      //Validation de l'entrée
                      validator: (val) => val.isEmpty ? 'Entrez votre email' : null,
                       onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                    
                  });
                },
                    ),
                  
           
                  SizedBox(height: 12,),
                
                  Material(
                    elevation: 2.5,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    shadowColor: Colors.white,
                     child: FlatButton(
                       focusColor: Colors.white,
                       highlightColor: Colors.white,
                     onPressed: () {
                    DatePicker.showTimePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (time) {
                      print('confirm $time');
                      
                      _time = '${time.hour} : ${time.minute} : ${time.second}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                    setState(() {});
                }, 
                child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                
                                  Text(
                                    " $_time",
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                         Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.deepOrange,
                                  ),
                      ],
                    ),
                ),
                color: Colors.white,
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
        Stream<DocumentSnapshot> provideDocumentFieldStream(String collection,String document ) {
    return Firestore.instance
        .collection(collection)
        .document(document)
        .snapshots();
}
 void custom_lunch(command)async{
  if(await canLaunch(command) ){
    await launch(command);
  }
  else{
    print('i could nt lunch $command');
  }
}
void _onMembreButtonPressed(){

  String text ;
  String _cle;
  String _current_user;
  String _current_userId;
   
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
      width: 100,
      height: 26,
      child: Text(
      "Membres",
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
     stream: Firestore.instance.collection('groupe').document('1314').collection('ListeMembre').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("aucun membre",

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
      
    _buildMemberlistItem(ctx,snapshot.data.documents[index])),
      );
    
     }
         )
    
       
      ) , 
       PositionedDirectional(
    top: 300,
    start: 275,
    child: 
        SizedBox(
      
      child:FloatingActionButton(onPressed:()=>null,
         child: Icon(Icons.add,
         size: 40,
         ),
         backgroundColor: const Color(0xffff5722),
         focusColor: Colors.white,
         ),
        ),
  ), ]
      )
         
          ),
        
          );
          
    
        }
        );
         
      }
_buildMemberlistItem(BuildContext ctx,DocumentSnapshot document) {
        final user = Provider.of<User>(context);
     return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("utilisateur",document['user']),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data;
           return  ListTile(
    title: Text(
                documentFields['identifiant'],
                      style: const TextStyle(
                          color:  const Color(0xde000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
     onTap: ()=> _afficherMembre(documentFields),
                      );
        }
    }
)
                  );
  }
  /*Affichage membre du groupe*/
_afficherMembre(Map<String, dynamic> document){

showModalBottomSheet(context: context, builder:(context){
     
      String url='assets/avatar.png';
      String phonenum = document['numtel'];
     print(phonenum);
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
  
     Container( 
     padding: EdgeInsets.symmetric(vertical:40,horizontal :20.0),
     child: ListView(children: [
                SizedBox(
                height:100,
                width: 100,
                child: Image(
                  image: AssetImage(url),
                  fit: BoxFit.contain,
                ),
              ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(document['identifiant'] ,
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
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(document['nom'] +" " + document['prenom'],
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
                  leading: Icon(Icons.phone, color: Colors.greenAccent,),
                  title: Text(document['numtel'],
                   style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left),
              
                ),
              
  
   
   ]

   ),
               
   ),
    
     
     PositionedDirectional(
    top: 290,
    start:100,
       child:  FlatButton(
          onPressed:()=>custom_lunch('tel:$phonenum'),
                      
         
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
              'Appeler',
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
      
      


});}
_buildMemberlistItem2(BuildContext ctx,DocumentSnapshot document) {
        final user = Provider.of<User>(context);
          StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("groupe",'1314'),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentAdmin = snapshot.data.data;
           if (documentAdmin['admin']==userData.identifiant){
            list_suggestion(context, '1314');
           }
           }
    }));          
                           }else{
                      return Text('Loading');
                    }
                  }
              );
     return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("utilisateur",document['user']),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data;
           return  ListTile(
    title: Text(
                documentFields['identifiant'],
                      style: const TextStyle(
                          color:  const Color(0xde000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
     onTap: ()=> _afficherMembre(documentFields),
                      );
        }
    }
)
                  );
  }
  void list_suggestion(BuildContext context,String idGroup){
   Container(
      color: const Color(0xff737373),
      child:Container(
      decoration: BoxDecoration(
       color: const Color(0xffffffff),
      borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(60) ,
          topRight:  const Radius.circular(60) ,
        ),
      ),
       child: Stack(children: [
     Container( 
     padding: EdgeInsets.symmetric(vertical:65.0,horizontal :20.0),
     child: StreamBuilder(
     stream: Firestore.instance.collection('groupe').document(idGroup).collection('suggestions').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData) return const Text("aucune suggestion",
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
    buildSugglistItem(ctx,snapshot.data.documents[index],idGroup)),
      );
     }
      )
      ) , 
      ]
      )
          ),
          );
        }
       
      
     buildSugglistItem(BuildContext ctx,DocumentSnapshot document,String idGroup) {
       return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("utilisateur",document['id']),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data;
           return  ListTile(
       
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children : <Widget>[  Text(
                documentFields['identifiant'],
                      style: const TextStyle(
                          color:  const Color(0xde000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
                       IconButton(onPressed:()=>_refuserSugg(idGroup,document.documentID), /*_refuserInvitation(document.documentID)*/
                         icon: Icon(
                        Icons.cancel,
                         color:  const Color(0xffff5722),
                         size: 30,
                        ),
                         ),
                         IconButton(onPressed:()=>  _accepterSugg(document.documentID,idGroup,document['id']),//a changer
                         icon: Icon(
                        Icons.check_circle,
                         color:  const Color(0xff13ef81),
                         size: 30,
                        ),
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
           );}}));
                    }
                    _refuserSugg(String groupId,String docId) {
              Firestore.instance.collection('groupe').document(groupId).collection('Suggestions').document(docId).delete().catchError((e){
              print(e);});
            }

_accepterSugg(String docId,String grpID,String userID) {
            //ajouter linvitation à la liste d'invi de cet utilisateur
            Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').document().setData({
              'id' : null,
            }).catchError((e){print(e);});
            
            //supprimer l'invitation
            Firestore.instance.collection('groupe').document(grpID).collection('Suggestions').document(docId).delete().catchError((e){
              print(e);});
          }
void list_invitations(BuildContext context, String userID){
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
     stream: Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').snapshots(),
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
    buildInvitationlistItem(ctx,snapshot.data.documents[index],userID)),
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
     buildInvitationlistItem(BuildContext ctx,DocumentSnapshot document , String userID) {
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
                      IconButton(onPressed:()=> _refuserInvitation(document.documentID,userID) /*_refuserInvitation(document.documentID)*/,
                         icon: Icon(
                        Icons.cancel,
                         color:  const Color(0xffff5722),
                         size: 30,
                        ),
                      
                         ),
                         IconButton(onPressed:()=>  _accepterInvitation(document.documentID,document['groupeID'],userID),//a changer
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
void _onParametrePressed(){
    showModalBottomSheet(context: context, builder:(context){
      final user = Provider.of<User>(context);
        String nom= 'nom';
       String email= 'email';
      String url='assets/avatar.png';
      String prenom = 'prénom';
      String utilisateur = 'user name';
       String phoneNumber=" num tel";
       final FirebaseAuth _auth = FirebaseAuth.instance;
 
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
     padding: EdgeInsets.symmetric(vertical:40,horizontal :20.0),
     child: ListView(children: [
                SizedBox(
                height:100,
                width: 100,
                child: Image(
                  image: AssetImage(url),
                  fit: BoxFit.contain,
                ),
              ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(nom +" " + prenom,
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
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(utilisateur,
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
                  leading: Icon(Icons.phone, color: Colors.greenAccent,),
                  title: Text(phoneNumber,
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
                  title: Text(email,
                   style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left),
              
                ),
  
   
   ]

   ),
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     

                  
   ),
    
     
      StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
     if (!snapshot.hasData) {return Container();
 
     }
      UserData userData=snapshot.data;
        phoneNumber=userData.numtel;
        nom=userData.nom;
        prenom=userData.prenom;
        utilisateur=userData.identifiant;
        email=_email();
        return Container();
   }
     ),
     
     PositionedDirectional(
    top: 20,
    start:100,
       child:  FlatButton(
          onPressed: () {

             Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        
                        EditProfileView()),
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

                  
                  



    
}



