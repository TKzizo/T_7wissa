import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mobile_popup/mobile_popup.dart';
import 'package:myapp/screens/home/camera.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/home/components/ProfilePicture.dart';
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
import 'package:myapp/services/Suggestion.dart'; 
import 'page_aide.dart'; 
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/src/rendering/shifted_box.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/services/MessageHandler.dart';


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
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  // text field state
  String nom = '';
  String lieu = 'Votre destination';
  String error =''; 
  String heure ='';
  String _supp = '';
  String _current_user; 
  String _current_userId; 
  String destination="Votre destination"; 
String _time = "Not set";
  Random random = new Random();
  List<dynamic> listMembre = null;
  String _admin = '';
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  Position position=Position(speed: 0);
  String searchAddr;
  double vitesse;
String text; 
FirebaseUser currentUser;
Widget _child; 
String _img='';
String _current_grp = '10000000';
String  _current_grp_adminID;
String  _current_grp_admin;
String _current_grp_destinaton;
String _current_grp_name;
String alerte='';
String placetogo=''; 
 FirebaseMessaging _fcm = FirebaseMessaging();
Map<String,dynamic> pass = new Map();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyAZRocDA5-kIiOwosJclZ1WEO5BYB2oPmo");
   


  @override
  void initState() {
    setCustomMapPin();
    getPermission();
    super.initState();
    _loadCurrentUser();

  }
  BitmapDescriptor pinLocationIcon;
   BitmapDescriptor panneIcon;
   BitmapDescriptor accidentIcon;
   BitmapDescriptor animauxIcon;
   BitmapDescriptor barrageIcon;
   BitmapDescriptor aideIcon;
   BitmapDescriptor pauseIcon;
   BitmapDescriptor radarIcon;
   BitmapDescriptor routeIcon;
   BitmapDescriptor maleIcon;
   BitmapDescriptor femaleIcon; 
   BitmapDescriptor destinationIcon; 

void setCustomMapPin() async {
      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size:Size(-12,-12)),
      'assets/jesuisenpanne.png');
      //ICONE EN PANNE 
       panneIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/jesuisenpanne.png');
      //ICONE ACCIDENT
       accidentIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/accident.png');
      //ICONE ANIMAUX
       animauxIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/animaux.png');
      //ICONE BARRAGE
       barrageIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)), 'assets/barrage.png');
      //ICONE AIDE
       aideIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/besoindaide.png');
      //ICONDE PAUSE 
       pauseIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/pause.png');
      //ICONE RADAR
       radarIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/radar.png');
      //ICONE ROUTE
       routeIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/route.png');
      //ICONE UTILISATEUR MALE
       maleIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/utilisateurmale.png');
      //ICONE UTILISATEUR FEMALE
       destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(-12,-12)),'assets/destination.png');
      //ICONE DESTINATION

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
        _getCurrentLocation();
    }
  }
  
   void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      vitesse = position.speed==null? 0.0: position.speed; 
       _child = _mapWidget();
    }
    );
    }


  void updateuserLocation(String userId){
    _getCurrentLocation();
    //
      Firestore.instance.collection('utilisateur').document(userId).updateData({'vitesse': position.speed==null? 0.0: position.speed.toDouble(),'latitude': position.latitude==null? 0.0: position.latitude.toDouble(), 'longitude':position.longitude==null? 0.0: position.longitude.toDouble()});
  }
    List<Marker> allMarkers = []; 
Widget _mapWidget() {
       return StreamBuilder(
      stream: Firestore.instance.collection('groupe').document(_current_grp).collection('Markers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container(child : Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange),);
        for (int i = 0; i < snapshot.data.documents.length; i++) {
          String icon= (snapshot.data.documents[i]['icon']).toString() ==null ?' ': (snapshot.data.documents[i]['icon']).toString();
          print("icon");  
          print(icon); 
          alerte=(snapshot.data.documents[i]['icon']).toString() ==null ?'alerte': (snapshot.data.documents[i]['icon']).toString(); 
          if(icon=='route'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:routeIcon,
                    infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
               
 
              ));
          }else{
             if(icon=='radar'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:radarIcon,
                    infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
              ));
          }else{
             if(icon=='pause'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:pauseIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
 
              ));
          }else{
              if(icon=='aide'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:aideIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
 
              ));
          }else{
             if(icon=='animaux'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:animauxIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
 
              ));
          }else{
              if(icon=='barrage'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:barrageIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
 
              ));
          }else{
            if(icon=='accident'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:accidentIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
 
              ));
          }else{
            if(icon=='panne'){
            allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:panneIcon,
                     infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),alerte),
                    ),
      
              ));
          }else{
              if(icon=='destination'){
                   placetogo=(snapshot.data.documents[i]['text']) ==null ?0.0: (snapshot.data.documents[i]['text']); 

               allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:destinationIcon,
                   infoWindow: InfoWindow(
                        title: 'Votre destination',
                    ),
                    onTap: ()=> _markerDestinationPressed(_current_userId,placetogo),
              )); 
              }else{
                 allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId(i.toString()),
                   icon:animauxIcon,
                 
  infoWindow: InfoWindow(
                        title: ("alerte"),
                        onTap:  ()=>  _markerAlertPressed((snapshot.data.documents[i]['senderId']).toString() ==null ?' ': (snapshot.data.documents[i]['senderId']).toString(),(snapshot.data.documents[i]['image']).toString() ==null ?"Alerte ! ": (snapshot.data.documents[i]['image']).toString()),
                    ), 
              ));
              }
             
          }
          }
          }
          }
          }
          }
          }
          }
        }  
      
        return userListeMarkers();    
      },
    );
  }
List<String> allUsers = []; 
Widget _eachUserMarker(){
     return StreamBuilder(
      stream: Firestore.instance.collection('utilisateur').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container(child: Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange),); 
        for (int i = 0; i < snapshot.data.documents.length; i++) {
          if(allUsers.contains((snapshot.data.documents[i]['uid']).toString() ==null ?"uid": (snapshot.data.documents[i]['uid']).toString())){
              allMarkers.add(new Marker(
              position: new LatLng((snapshot.data.documents[i]['latitude']) ==null ?0.0: (snapshot.data.documents[i]['latitude']),
                 (snapshot.data.documents[i]['longitude']) ==null ?0.0: (snapshot.data.documents[i]['longitude'])),
                   markerId: MarkerId((snapshot.data.documents[i]['uid']).toString() ==null ?"uid": (snapshot.data.documents[i]['uid']).toString()),
                   icon:maleIcon,
                     infoWindow: InfoWindow(
                        title: (snapshot.data.documents[i]['identifiant']).toString() ==null ?"user": (snapshot.data.documents[i]['identifiant']).toString(),
                        onTap:  ()=> _markerUserPressed((snapshot.data.documents[i]['uid']).toString() ==null ?null: (snapshot.data.documents[i]['uid']).toString()),
                    ),
              ));
          }
         
        }  
        return GoogleMap(
                markers: Set.from(allMarkers),
                initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude,position.longitude),
                zoom: 12.0),
                onMapCreated: (GoogleMapController controller) {_controller = controller; },
                );    
      },
    );
}
  
 Widget  userListeMarkers(){
    return   StreamBuilder(
      stream: Firestore.instance.collection('groupe').document(_current_grp).collection('ListeMembre').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return Container(child: Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange),);
        for (int i = 0; i < snapshot.data.documents.length; i++) { 
          allUsers.add((snapshot.data.documents[i]['user']).toString() ==null ?" ": (snapshot.data.documents[i]['user']).toString());              
        }  
    return  _eachUserMarker(); 
      },

    );
  }
Widget map(){ 
    return    GoogleMap(
                markers: Set.from(allMarkers),
                initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude,position.longitude),
                zoom: 12.0),
                onMapCreated: (GoogleMapController controller) {_controller = controller; },
                );
  
}
void _markerAlertPressed(String uid, String alerte){
     showDialog(context: context, builder:(context){
       String icone=''; 
        if(alerte=='route'){
                        icone='assets/routeendommagée';

                    }else{
                      if(alerte=='radar'){
                        icone='assets/radar.png';
                      }else{
                        if(alerte=='pause'){
                          icone='assets/pause.png';
                        }else{
                          if(alerte=='aide'){
                            icone='assets/besoindaide.png';
                          }else{
                            if(alerte=='animaux'){
                              icone='assets/animaux.png';
                            }else{
                              if(alerte=='barrage'){
                                icone='assets/barrage.png';
                              }else{
                               if(alerte=='accident'){
                                 icone='assets/accident.png';
                               }else{
                                 if(alerte=='panne'){
                                   icone='assets/jesuisenpanne.png';
                                 }else{
                                  icone='assets/destination.png';
                                 }
                               }
                              }

                            }
                          }
                        }
                      }
                    }
  return AlertDialog(
    elevation: 1,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title :  Text('On vous signale une alerte ! ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 19.0
                            ),),
  content: Stack(children: [
    
   Container( 
     padding: EdgeInsets.symmetric(vertical:0.0,horizontal :20.0),
      child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               Image(
                    image: AssetImage(icone),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10,), 
               
                    Text('une alerte a été signalée : ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 7,),
                              Text(alerte,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),                
              ],
            ),
          ),
       
      ),
       
      
      ]
      ),
   actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });
    
        
         
  }
  
  

void _markerDestinationPressed(String userId, String placetogo){
     showDialog(context: context, builder:(context){
  return AlertDialog(
    elevation: 1,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title :  Text('Votre destination',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 19.0
                            ),),

  content: Stack(children: [
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid:userId).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return    Container( 
     padding: EdgeInsets.symmetric(vertical:0.0,horizontal :20.0),
      child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                 Image(
                    image: AssetImage('assets/destination.png'),
                    fit: BoxFit.contain,
                  ),
                SizedBox(height: 20,), 
                 
                                          
                 SizedBox(height: 18,), 
              
                    Text('Vous vous dirigé vers',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                              Text(placetogo,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.italic,
                                fontSize: 17.0
                            ),),
                               
              ],
            ),
          ),
       
      );
                    }else{
                      return Container(child: Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange),);
                    }
                  }
              ),
       
      
      ]
      ),
   actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });
    
        
  }
   void _markerPausePressed(String userId, String pause){
     showDialog(context: context, builder:(context){
  return AlertDialog(
    elevation: 1,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title :  Text('Un arrêt est prévu',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 19.0
                            ),),

  content: Stack(children: [
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid:userId).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return    Container( 
     padding: EdgeInsets.symmetric(vertical:0.0,horizontal :(MediaQuery.of(context).size.height) * 0.02),
      child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                 Image(
                    image: AssetImage('assets/pause.png'),
                    fit: BoxFit.contain,
                  ),
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.02,), 
                 
                                          
                 SizedBox(height: (MediaQuery.of(context).size.height) * 0.02,), 
              
                    Text('Votre partenaire de route',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                    Text(destination,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.italic,
                                fontSize: 17.0
                            ),),
                               
              ],
            ),
          ),
       
      );
                    }else{
                      return Container(child: Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange),);
                    }
                  }
              ),
       
      
      ]
      ),
   actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });
    
        
  }

/************************************************** */
  void _markerUserPressed(String userId){
     showDialog(context: context, builder:(context){
       String icone=''; 
  return AlertDialog(
    elevation: 1,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title :  Text('Information sur votre partenaire de route  ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 19.0
                            ),),
  content: Container(
    height: 300,
    width: 200,
    child: Stack(children: [
      
     
          StreamBuilder<UserData>(
                    stream: DatabaseService(uid:userId).utilisateursDonnees,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        UserData userData=snapshot.data;
                        print(userData.identifiant);
                        return    Container( 
       padding: EdgeInsets.symmetric(vertical:0.0,horizontal :20.0),
        
              child: Column(
                children: <Widget>[
                  ClipOval(
                     child: SizedBox(
                       width: 120.0,
                       height: 120.0,
                       
                       child: Image.network(userData.image_url.toString(),fit: BoxFit.fill,),
                       
                     ),
                     ),
                    SizedBox(height: 10,), 
                 
                      Text('Votre partenaire de route',
                      textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 17.0
                              ),),
                              SizedBox(width: 7,),
                                Text(userData.identifiant,
                      textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color:  Colors.teal,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 17.0
                              ),),
                               SizedBox(width: 7,),
                              
                              
                    
                  
                   SizedBox(height: 20,), 
                 
                      Text('Roule à une vitesse de : ',
                      textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 17.0
                              ),),
                              SizedBox(width: 12,),
                                SizedBox(
                                  width: 40,height: 20,
                                                                child: Text(userData.vitesse.toString(),
                      textAlign: TextAlign.center,
                              style: const TextStyle(
                                    color:  Colors.deepOrange,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                    fontStyle:  FontStyle.italic,
                                    fontSize: 17.0
                              ),),
                                ),
                                  
                ],
              ),
            
         
        );
                      }else{
                             
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 60,), 
                            PlaceholderLines(count: 3, animate: true, color: Colors.grey,align: TextAlign.center, minOpacity: 0.2, maxOpacity: 0.4, ),
                          ],
                        );
                      }
                    }
                ),
         
        
         
        
        ]
        ),
  ),
   actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });
    
        
         
  }




  /********************************** */
/*void _markerUserPressed(String userId){
     showDialog(context: context, builder:(context){
  return AlertDialog(
    elevation: 1,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title :  Text('Informations sur votre partenaire de route ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 19.0
                            ),),
  content: Stack(children: [
    
    StreamBuilder<UserData>(
                  stream: DatabaseService(uid:userId).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      return    Container( 
     padding: EdgeInsets.symmetric(vertical:0.0,horizontal :20.0),
      child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipOval(
                   child: SizedBox(
                     width: 120.0,
                     height: 120.0,
                     
                     child: Image.network(userData.image_url.toString(),fit: BoxFit.fill,),
                     
                   ),
                   ),
                  SizedBox(height: 10,), 
               
                    Text('Votre partenaire de route',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 7,),
                              Text(userData.identifiant,
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.teal,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                             SizedBox(width: 7,),
                            
                            
                  
                
                 SizedBox(height: 20,), 
               
                    Text('Roule à une vitesse de : ',
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 17.0
                            ),),
                            SizedBox(width: 12,),
                              SizedBox(
                                width: 40,height: 20,
                                                              child: Text(userData.vitesse.toString(),
                    textAlign: TextAlign.center,
                            style: const TextStyle(
                                  color:  Colors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto",
                                  fontStyle:  FontStyle.italic,
                                  fontSize: 17.0
                            ),),
                              ),
                                
              ],
            ),
          ),
       
      );
                    }else{
                           
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 60,), 
                          PlaceholderLines(count: 3, animate: true, color: Colors.grey,align: TextAlign.center, minOpacity: 0.2, maxOpacity: 0.4, ),
                        ],
                      );
                    }
                  }
              ),
       
      
      ]
      ),
   actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });
    
        
         
  }*/
  
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
  String pause="Planifiez votre pause"; 
  double latt; 
  double lang; 
/*METHODES RECHERCHES ET AUTOCOMPLETE*/ 
Future<Null> displayPrediction(Prediction p) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    latt=lat; 
    lang=lng; 
    final coordinates = new Coordinates(lat, lng);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    pause= "${first.featureName} : ${first.addressLine}";
    destination= "${first.featureName} : ${first.addressLine}";
    lieu = "${first.featureName} : ${first.addressLine}";
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


 


/*COMPOSANTS*/ 


 
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
      BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );
    return Scaffold(
 resizeToAvoidBottomInset: true,
      /*Bar*/
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child : AppBar(
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        elevation: 3.0,
        actions: <Widget>[
              IconButton(icon: Icon(Icons.notifications_active), onPressed:() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MsgHandler()));
              } )
            ],
        title: Text('Acceuil'),

      ) ),
      /*MENU*/
      bottomNavigationBar:   BottomAppBar(
          color: Colors.white.withOpacity(0.5),

      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      _current_userId = user.uid;
                      
                      UserData userData=snapshot.data;
                      _img = userData.image_url;
                      _current_user=userData.identifiant; 
                      updateuserLocation(_current_userId);
                  updatePinOnMap(_current_userId,_current_user);
                      return  Text(
                          '');
                    }else{
                      return Text('');
                    }
                  }
              ),
           Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                      heroTag: 'btn1',
                      onPressed: () => _onBreakButtonPressed(),
                      child: Icon(
                       Icons.free_breakfast,
                      size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),

            Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                        heroTag: 'btn2',
                      onPressed: ()=> _onMessageButtonPressed(_current_grp),
                      child: Icon(
                       Icons.email,
                      size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
            
              Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                        heroTag: 'btn3',
                      onPressed:() =>_onGroupButtonPressed(_current_grp),
                      child: Icon(
                       Icons.group,
                      size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
           
              Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                        heroTag: 'btn4',
                      onPressed: () =>onMembreButtonPressed(),
                      child: Icon(
                       Icons.view_list,
                      size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
                   Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                      heroTag: 'btn15',
                      onPressed: ()=>list_invitations(context, _current_userId)  , 
                      child: Icon(
                       Icons.add_alert,
                     size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
                    Container(
                     width: (MediaQuery.of(context).size.width) * 0.1,
                     height: (MediaQuery.of(context).size.height) * 0.052,
                      child: FloatingActionButton(
                        heroTag: 'btn5',
                      onPressed: () {
                        //list_invitations(context, _current_userId); 
                        changer_destination();
                      },
                      child: Icon(
                       Icons.place,
                      size: (MediaQuery.of(context).size.height) * 0.035,
                       ),
                        backgroundColor: const Color(0xff339899),
                        focusColor: Colors.white,
                   ),
                  ),
          Text(''),        
        ],
      ),
    ),
        
      body:   SlidingUpPanel(
       backdropEnabled: true,
      panelBuilder: (ScrollController sc) => _scrollingmessagesList(sc),
      body: _child,
      
       borderRadius: radius ,
       minHeight: (MediaQuery.of(context).size.height) * 0.015,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
             height: (MediaQuery.of(context).size.height) * 0.1,
            ),
           
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             mainAxisSize: MainAxisSize.min,

             
             children: <Widget>[
               
               Container(
                color: Colors.white24,
                height: (MediaQuery.of(context).size.width) * 0.05,
                width: (MediaQuery.of(context).size.height) * 0.05,
               ),
               StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      _current_userId = user.uid;
                      
                      UserData userData=snapshot.data;
                      _img = userData.image_url;
                      print(userData.identifiant);
                      print(_img);

                      return   Align(
                 alignment: Alignment.center,
                
                   child: ClipOval(
                   child: SizedBox(
                     width: (MediaQuery.of(context).size.width) * 0.3,
                     height: (MediaQuery.of(context).size.height) * 0.16,
                     
                     child: Image.network(_img,fit: BoxFit.fill,),
                     
                   ),
                   ),
                 
               );
                    }else{
                      return Loading(indicator: BallPulseIndicator(), size:50,color: Colors.deepOrange);
                    }
                  }
              ),
              

                IconButton(
                  
                  icon: Icon( Icons.camera_alt,
               size:(MediaQuery.of(context).size.height) * 0.035,
                 color: Colors.greenAccent
             ),
                padding: EdgeInsets.only(top:(MediaQuery.of(context).size.height) * 0.1, right: (MediaQuery.of(context).size.height) * 0.03,), 
                
             onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ProfilPicture()),
                      );
                      }
                      ),
                     
             
             ]
           ),
            
                      SizedBox(
             height: (MediaQuery.of(context).size.height) * 0.02,
            ),
           
            Expanded(
              flex: 1,
              child: StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      _current_userId = user.uid;
                      
                      UserData userData=snapshot.data;
                      _img = userData.image_url;
                      print(userData.identifiant);
                      print(_img);

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
                  leading: Icon(Icons.settings, color: Colors.greenAccent),
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
                   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  HelpPage()),
                      );

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
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.13,),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.greenAccent,),
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
              'user' : userID,
            }).catchError((e){print(e);});       
            //ajouter le groupe dans la liste des groupes de l'utilistateur
            Firestore.instance.collection('utilisateur').document(userID).collection('ListeGroupe').document().setData({
              'id' : grpID,
            }).catchError((e){print(e);});
            //supprimer l'invitation
            Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').document(docId).delete().catchError((e){
              print(e);});
            
          }

  void _onAddMarkerButtonPressed(double latitude,double longitude) {
    InfoWindow infoWindow =
    InfoWindow(title: "Location" + markers.length.toString());
    Marker marker = Marker(
      markerId: MarkerId(markers.length.toString()),
      infoWindow: infoWindow,
      position: new LatLng(latitude,longitude),
      icon: pauseIcon,
    );
    setState(() {
      allMarkers.add(marker);
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
                          color:  Colors.teal,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),
         trailing:    Text(
                       document['time'].toString(),
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize:12.0
                      ),
                      textAlign: TextAlign.left                
                      ),


        onTap:()  {
          showMobilePopup(
    context: context,
    builder: (context) => MobilePopUp(
        title: document['sender'].toString(),
                    leadingColor: Colors.white,
        child: Builder(
           builder: (navigator) => Scaffold(
              resizeToAvoidBottomInset: true,
                            body: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                   Image.network(document['image']),
                                  
                                ],
                              ),
                            ),
                          ),
        ),
    ),
);
        }

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
                       document['time'].toString(),
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
  padding: EdgeInsets.symmetric(vertical:(MediaQuery.of(context).size.height) * 0.04,horizontal:(MediaQuery.of(context).size.height) * 0.04),
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
     print(_current_user);
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp,'On a démarré!', _current_user,_current_userId,null);
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
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp,'Je suis en route !', _current_user,_current_userId,null);
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
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(/*_current_grp.toString()*/_current_grp,'Je suis arrivé(e)', _current_user,_current_userId,null);
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
   CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "j'ai besoin d'aide !", position.longitude, position.latitude, _current_userId, "aide");
     allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon: aideIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"j'ai besoin d'aide ! "),
              ));     
              setState(() {
                 _child=_mapWidget();
              });
             
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp,'J''ai besoin d''aide ! ', _current_user,_current_userId,null);
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
    CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "je suis en panne !", position.longitude, position.latitude, _current_userId, "panne");
     allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon:panneIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"je suis en panne"),
              ));
               setState(() {
                 _child=_mapWidget();
              });
              
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp,'Je suis en panne ! ', _current_user,_current_userId,null);
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
    CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "Un accident!", position.longitude, position.latitude, _current_userId, "accident");
    allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon:accidentIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"accident"),
              ));
               setState(() {
                 _child=_mapWidget();
              });
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(/*_current_grp.toString()*/_current_grp,'Un accident !', _current_user,_current_userId,null);
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

     ChatService(uid: _current_grp.toString() ).envoyer_mesg(/*_current_grp.toString()*/_current_grp,'Route endommagée ! ', _current_user,_current_userId,null);
    CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "Route endommagée  !", position.longitude, position.latitude, _current_userId, "route");
    allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon:routeIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"Route endommagée"),
              ));
 setState(() {
                 _child=_mapWidget();
              });
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
    CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "Alerte barrage !", position.longitude, position.latitude, _current_userId, "barrage");
    allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon:barrageIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"Alerte barrage"),
              ));
 setState(() {
                 _child=_mapWidget();
              });
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp,'Alerte Barage ! ', _current_user,_current_userId,null);
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
    CreationGroupeServises(uid: _current_grp.toString()).marquer_Alerte(_current_grp, "Alerte radar!", position.longitude, position.latitude, _current_userId, "radar");
    allMarkers.add(new Marker(
              position: new LatLng(position.latitude,position.longitude),
                   markerId: MarkerId(_current_grp.toString()),
                   icon:radarIcon,
                onTap:  ()=> _markerAlertPressed(_current_userId,"radar"),
              ));
     setState(() {
                 _child=_mapWidget();
              });
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp.toString(),'Alerte radar !', _current_user,_current_userId,null);
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
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp.toString(),'Appelez moi  !', _current_user,_current_userId,null);
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
     ChatService(uid: _current_grp.toString() ).envoyer_mesg(_current_grp.toString(),'OK  !', _current_user,_current_userId,null);
     },
     icon: Icon(Icons.send,color: Colors.greenAccent),
     ), 
   ),
  
    ],
    
  ));
 
}
void _onMessageButtonPressed(String currentGroupe){
 
   
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,

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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.4,
      height: (MediaQuery.of(context).size.height) * 0.03,
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
     padding: EdgeInsets.symmetric(vertical:(MediaQuery.of(context).size.height) * 0.065,horizontal :(MediaQuery.of(context).size.width) * 0.04),
     child: StreamBuilder(
     stream: Firestore.instance.collection('chat').document(currentGroupe).collection('messages').snapshots(),
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
    top: (MediaQuery.of(context).size.height) * 0.45,
    start:(MediaQuery.of(context).size.width) * 0.1,
       child: SizedBox(
      width:(MediaQuery.of(context).size.width) * 0.8,
      height: (MediaQuery.of(context).size.height) * 0.08,
      child:
       
       ListTile(
   title:  TextField(
      keyboardType: TextInputType.multiline,
      maxLength: null,
      maxLines: null,
     decoration: InputDecoration(
       hintText: "Envoyer..",
                       suffixIcon : IconButton(icon:Icon(Icons.camera_alt,color: Colors.greenAccent),onPressed:()async{
    
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ImageCapture(groupeID: _current_grp)),
                      );})),
                 onChanged: (val) {
                   
                  setState(() => text = val);
                },
                       
  ), 
trailing:  IconButton(onPressed:() async {      
     ChatService(uid: currentGroupe.toString() ).envoyer_mesg(currentGroupe.toString(),text, _current_user,_current_userId,null);
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
_onGroupButtonPressed(String currentUser){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
        width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,

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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.4,
      height: (MediaQuery.of(context).size.height) * 0.03,
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
     padding: EdgeInsets.only(
       
     top: (MediaQuery.of(context).size.height) * 0.075,
     bottom: (MediaQuery.of(context).size.height) * 0.02,
     left: (MediaQuery.of(context).size.width) * 0.04,
     right: (MediaQuery.of(context).size.width) * 0.04,
       ),
     child: StreamBuilder(
     stream: Firestore.instance.collection('utilisateur').document(_current_userId).collection('ListeGroupe').snapshots(),
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



    top: (MediaQuery.of(context).size.height) * 0.44,
    start: (MediaQuery.of(context).size.width) * 0.8,
    child: 
        SizedBox(
      
      child:FloatingActionButton(heroTag: 'btn6',onPressed:()=>creeGroupe(),
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
  afficher_alerte(){

 showDialog(context: context, builder:(context){
  return AlertDialog(
  title : Text('Alerte'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  content: Text("Vous n'avez pas le droit de lancer cette fonctionalité car vous n'êtes pas l'administrateur de ce groupe."),
  actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('OK'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });

 }
     _buildlistItem(BuildContext ctx,DocumentSnapshot document) {
       DocumentReference ref = Firestore.instance.collection('groupe').document(_current_grp);
      return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("groupe",document['id']),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if ((snapshot.hasData)&& (document['id']!='10000000')) {
           Map<String, dynamic> documentFields = snapshot.data.data;
//bool isSwitched=documentFields['statu'];
           var listTile = ListTile(
title:Row (
       
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children : <Widget>[
       Text(
      documentFields['nom'].toString(),
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
     SizedBox(
        width: (MediaQuery.of(context).size.width) * 0.14,
       height: (MediaQuery.of(context).size.height) * 0.045,
            child: Text(  "à : "+ documentFields['destination'],
                        style: const TextStyle(
                            color:  const Color(0xff52bf90),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                        ),
                        textAlign: TextAlign.left,
                        ),
     ),
     ]),
     subtitle :   Text(
                      "Admin : "+ documentFields['admin'].toString(),
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),


    /*title:Row (
       
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children : <Widget>[
       Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[

           Text(
      documentFields['nom'],
      style: const TextStyle(
              color:  const Color(0xff3d3d3d),
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle:  FontStyle.normal,
              fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
      
     SizedBox(
      height: (MediaQuery.of(context).size.height) * 0.06,
      child : Text(
                      "Admin : "+ documentFields['admin'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),),
         ],
       ),
      Spacer(flex:1,),
      Column (
        children: <Widget>[ 

     SizedBox(
       width: 70, 
       height: 30,
            child: Text(  "à : "+ documentFields['destination'],
                        style: const TextStyle(
                            color:  const Color(0xff52bf90),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                        ),
                        textAlign: TextAlign.left,
                        ),
     ),
        /*       Switch(
            value: isSwitched,
            onChanged: (value) async{
              setState(() {
                isSwitched = value;
                print(isSwitched);
              });
              await ref.updateData({"statu": !(documentFields['statu'])});
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),*/
                      ],),
                      
                      ]),*/

     /*subtitle :   Text(
                      "Admin : "+ documentFields['admin'],
                      style: const TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.left                
                      ),*/
        trailing:    Column(
          
           children: <Widget>[
             /*Switch(
            value: isSwitched,
            onChanged: (value) {
              if (_current_grp_adminID == _current_userId){
              setState(() {
                isSwitched = value;
                print(isSwitched);
                
              });
               ref.updateData({"statu": isSwitched});} else afficher_alerte();
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),*/
             IconButton(onPressed:()=> _quittergroupe(document.documentID,documentFields['uid']),
                             icon: Icon(
                            Icons.exit_to_app,
                             color:  const Color(0xffff5722),
                            ),
                          
                             ),
           ],
         ),
                       onTap:() async{

                          if (_current_grp != null) {
                 await _fcm.unsubscribeFromTopic("groupe/$_current_grp/Markers");

                 _current_grp = document['id'].toString();

                await Firestore.instance
                    .collection("groupe")
                    .document(_current_grp)
                    .get()
                    .then((value) {
                  _current_grp_admin = value.data["admin"];
                  _current_grp_destinaton = value.data["destination"];
                  _current_grp_name=value.data["nom"];
                  pass["admin"] = value.data["admin"];
                  pass["destination"] = value.data["destination"];
                  pass["groupe"] = value.data["nom"];
                  pass["groupeID"] = value.data["uid"];
                });
                await Firestore.instance
                    .collection("utilisateur")
                    .where("identifiant", isEqualTo: _current_grp_admin)
                    .getDocuments()
                    .then((value) {
                  _current_grp_adminID = value.documents[0].data["uid"];
                });

                 await _fcm.subscribeToTopic("groupe/$_current_grp/Markers");
                  
                  for (int j = 0; j< allMarkers.length; j++){
                    allMarkers.removeAt(0); 
                  }


               //      allMarkers.clear(); 
               setState(() {
           allMarkers.removeWhere((item) => item != null);
           print(allMarkers.length); 
                 _child=_mapWidget();
              });
                   
                         }
                       });
           return  listTile; }else{
                        return SizedBox(height: 1,); 
                      }
                      })
      ); //
                    }

_quittergroupe(docId,docgrpID) {
  // Suppression du groupe de la liste des groupes de l'utilisateur
  Firestore.instance.collection('utilisateur')
    .document(_current_userId)
    .collection('ListeGroupe')
    .document(docId)
    .delete()
    .catchError((e){
    print(e);}); 
  // Pour récupérer le document qui contient l'utilisateur courant dans la liste des membres de ce groupe
  Firestore.instance
    .collection("groupe").document(docgrpID).collection('ListeMembre')
    .where("user", isEqualTo: _current_userId)
    .getDocuments()
    .then((value) {
  _supp = value.documents[0].documentID; 
  // Supprimer cet utilisateur de la liste des membres             
  Firestore.instance.collection("groupe")
    .document(docgrpID)
    .collection('ListeMembre')
    .document(_supp)
    .delete()
    .catchError((e){
    print(e);});});   
  }


void creeGroupe(){
  int _id = random.nextInt(10000);
    showModalBottomSheet(context: context, builder:(context){
        
     return Container(

        color: const Color(0xff737373),
       width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
        child: Container(
        decoration: BoxDecoration(
       color: const Color(0xffffffff),
        borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(30) ,
          topRight:  const Radius.circular(30) ,
        ),
        ),
      child : Stack(
              children: <Widget>[ 
                 PositionedDirectional(
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.4,
      height: (MediaQuery.of(context).size.height) * 0.03,
      child: Text(
      "Créer un groupe ",
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
          padding: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height) * 0.01, horizontal:(MediaQuery.of(context).size.width) * 0.1),
          child : Form(
            key : _formKey,
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.03),
                TextFormField(
                  decoration: const InputDecoration(
                   hintText: '   Nom du groupe',
                    ),
                  validator: (val) => val.isEmpty ? 'Donner un nom ' : null,
                  onChanged: (val) {
                    setState(() => nom = val);
                    
                  },
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.015),
              Material(
                      elevation: 2.5,
                      //borderRadius: BorderRadius.circular(30.0),
                      borderRadius: BorderRadius.zero,
                      color: Colors.white,
                      shadowColor: Colors.white,
                       child: FlatButton(
                         focusColor: Colors.white,
                         highlightColor: Colors.white,
                       onPressed:   _handlePressButton,
  child: Container(
                      alignment: Alignment.center,
                      height: (MediaQuery.of(context).size.height) * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                  
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height) * 0.03,
                                      width: (MediaQuery.of(context).size.width) * 0.4,  
                                      child: Text(
                                        destination ==null ?'Destination':destination,
                                        style: TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                           Icon(
                                      Icons.search,
                                      size: 18.0,
                                      color: Colors.deepOrange,
                                    ),
                        ],
                      ),
                  ),
                  color: Colors.white,
                ),
                    ),
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.015),
                /*Heure de depart*/ 
                 Material(
                      elevation: 2.5,
                      borderRadius: BorderRadius.zero,
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
                      height: (MediaQuery.of(context).size.height) * 0.05,
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
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
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
                     SizedBox(height: (MediaQuery.of(context).size.height) * 0.09,),
                     SizedBox(width: (MediaQuery.of(context).size.width) * 0.65,),
                    SizedBox(
                      height:(MediaQuery.of(context).size.height) * 0.05 ,
                      width: (MediaQuery.of(context).size.width) * 0.1,
                       child: FloatingActionButton(
                         backgroundColor: Color(0xffff5722),
                         heroTag: 'btn10000',
                         child: Icon(Icons.add, 

                          size: 30,),
                         
                         
                         onPressed: () async {
                            pass["admin"] = _current_user;
                  pass["destination"] = destination;
                  pass["groupe"] = nom;
                  pass["groupeID"] = _id;
                           showSearch(context: context, delegate: UserSeach(pass));}
                        ),
                     ),
                    ],      
                ),
                
                 Row(
                   children: <Widget>[
                     SizedBox(width:(MediaQuery.of(context).size.width) * 0.6,),
                     Text('Ajouter des\n membres'),
                   ],
                 ),
                
                SizedBox(height:(MediaQuery.of(context).size.height) * 0.02),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child: 
                  MaterialButton(
                  minWidth: (MediaQuery.of(context).size.width) * 0.35,
                  height: (MediaQuery.of(context).size.height) * 0.036,
                  child: 
                  Text("Créer",
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
                     
                      
                      CreationGroupeServises(uid: _id.toString() ).creerGroupe(_current_user,destination, _time, listMembre, nom,_current_userId);
                      CreationGroupeServises(uid: _id.toString()).marquer_Alerte(_id.toString(), destination, lang, latt, _current_userId, "destination");

                   allMarkers.add(new Marker(
                           position: new LatLng(latt,lang),
                            markerId: MarkerId('destination'),
                            icon:destinationIcon, 
                            onTap: ()=> _markerDestinationPressed(_current_userId,destination),
                ));    
                setState(() {
                                 

                  
                   _child=_mapWidget();
                });
                    }
                  }
                ),
                ), 
              ],
            ),
          ),
        ),],
      ),
      )
     );
    }
    );
    
  }
   changer_destination(){
     DocumentReference ref = Firestore.instance.collection('groupe').document(_current_grp);
     print(_current_userId);
     print(_current_grp_adminID);
   if(_current_userId==_current_grp_adminID){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
       width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.7,
      height: (MediaQuery.of(context).size.height) * 0.03,
      child: Text(
      "Changer destination",
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
               padding: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height) * 0.1, horizontal:(MediaQuery.of(context).size.width) * 0.1),
     child: Form(
          key : _formKey,
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height:(MediaQuery.of(context).size.height) * 0.01),
            
           
                    Material(
                      elevation: 2.5,
                      //borderRadius: BorderRadius.circular(30.0),
                      borderRadius: BorderRadius.zero,
                      color: Colors.white,
                      shadowColor: Colors.white,
                       child: FlatButton(
                         focusColor: Colors.white,
                         highlightColor: Colors.white,
                       onPressed:   _handlePressButton,
  child: Container(
                      alignment: Alignment.center,
                      height: (MediaQuery.of(context).size.height) * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                  
                                    SizedBox(
                                      height: (MediaQuery.of(context).size.height) * 0.03,
                                      width: (MediaQuery.of(context).size.width) * 0.4,  
                                      child: Text(
                                        lieu ==null ?'Destination':lieu,
                                        style: TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                           Icon(
                                      Icons.search,
                                      size: 18.0,
                                      color: Colors.deepOrange,
                                    ),
                        ],
                      ),
                  ),
                  color: Colors.white,
                ),
                    ),
                  
                  ])),),
       PositionedDirectional(
    top: (MediaQuery.of(context).size.height) * 0.3,
    start: (MediaQuery.of(context).size.width) * 0.3,
    child: 
        SizedBox(
      
      child:Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child: 
                  MaterialButton(
                  minWidth: (MediaQuery.of(context).size.width) * 0.35,
                  height: (MediaQuery.of(context).size.height) * 0.036,
                  child: 
                  Text("Changer",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color:  const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle:  FontStyle.normal,
                        fontSize: 16.0
                    ),
                  ),
        onPressed:()=>{ if(_formKey.currentState.validate()){ 
         
    ref.updateData({"destination": lieu})         
                    
                  }},
         
                  ),
        ),
  ), 
  ),
       ],),
         
          ),
        
          );
          
    
        }
        );
         
      }              
       else{
      afficher_alerte();

 }
  }
  void _onBreakConfirmationPressed(){
    showDialog(context: context, builder:(context){
  return AlertDialog(
  title :  Text('Voulez vous confirmer ? ',
                textAlign: TextAlign.center,
                        style: const TextStyle(
                            color:  const Color(0xde204f6f),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 19.0
                        ),),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
/* content: Stack(children: [
  
      
      ]
      ),*/
  actions: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: (MediaQuery.of(context).size.width) * 0.1),
                  MaterialButton(
                       minWidth: (MediaQuery.of(context).size.width) * 0.2,
                      height: (MediaQuery.of(context).size.height) * 0.036,
                      child:
                      Text("OUI",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color:  Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        ),
                      ),
                      onPressed: () {
                        print('adding'); 
                        allMarkers.add(new Marker(
                         position: new LatLng(latt,lang),
                          markerId: MarkerId('pause'),
                          icon:pauseIcon, 
              ));
              setState(() {
                 _child=_mapWidget();
              });
              print('done');
              Navigator.of(context).pop();
                      }
                  ),
                    SizedBox(width: (MediaQuery.of(context).size.width) * 0.1),    
                  MaterialButton(
                       minWidth: (MediaQuery.of(context).size.width) * 0.2,
                      height: (MediaQuery.of(context).size.height) * 0.036,
                      child:
                      Text("NON",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        ),
                      ),
                      onPressed: () {Navigator.of(context).pop();}
                  ),
                 SizedBox(width: (MediaQuery.of(context).size.width) * 0.1),
                ],),
  ],

  );
 });
  
         
  }
  void _onBreakButtonPressed(){
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
      width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.8,
      height: (MediaQuery.of(context).size.height) * 0.03,
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
     padding: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height) * 0.1, horizontal:(MediaQuery.of(context).size.width) * 0.1),
          key: _formKey,
          child: SingleChildScrollView(
            child:SingleChildScrollView(
                          child: Column(
                children: <Widget>[
                  SizedBox(height: (MediaQuery.of(context).size.height) * 0.012),       
            Material(
                    elevation: 2.5,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    shadowColor: Colors.white,
                     child: FlatButton(
                       focusColor: Colors.white,
                       highlightColor: Colors.white,
                     onPressed:   _handlePressButton,

                   
                child: Container(
                    alignment: Alignment.center,
                    height: (MediaQuery.of(context).size.height) * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                
                                  SizedBox(
                                    height: (MediaQuery.of(context).size.height) * 0.03,
                                    width: (MediaQuery.of(context).size.width) * 0.5,  
                                    child: Text(
                                      pause ==null ?'Position':pause,
                                      style: TextStyle(
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                         Icon(
                                    Icons.search,
                                    size: 18.0,
                                    color: Colors.deepOrange,
                                  ),
                      ],
                    ),
                ),
                color: Colors.white,
              ),
                  ),
                  SizedBox(height: (MediaQuery.of(context).size.height) * 0.012),
                
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
                    height: (MediaQuery.of(context).size.height) * 0.05,
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
                          color:  const Color(0xde3d3d3d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
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
                   SizedBox(height: (MediaQuery.of(context).size.height) * 0.04),
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.deepOrange,
                    child:
                    MaterialButton(
                        minWidth: (MediaQuery.of(context).size.width) * 0.3,
                        height:(MediaQuery.of(context).size.height) * 0.036,
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
       
      ),
       
       
      
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
void onMembreButtonPressed(){

  
    String text ;
  String _current_user;
  String _current_userId;
    final user = Provider.of<User>(context);
    showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
      width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.8,
      height: (MediaQuery.of(context).size.height) * 0.03,
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
      padding: EdgeInsets.only(
       
     top: (MediaQuery.of(context).size.height) * 0.075,
     bottom: (MediaQuery.of(context).size.height) * 0.02,
     left: (MediaQuery.of(context).size.width) * 0.04,
     right: (MediaQuery.of(context).size.width) * 0.04,
       ),
     child: StreamBuilder(
     stream: Firestore.instance.collection('groupe').document(_current_grp).collection('ListeMembre').snapshots(),
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
    top: (MediaQuery.of(context).size.height) * 0.43,
    start: (MediaQuery.of(context).size.width) * 0.75,
    child: 
        SizedBox(
      
      child:FloatingActionButton(heroTag: 'btn8',onPressed:() {
        if (currentUser.uid == _current_grp_adminID )
        { showSearch(context: context, delegate: UserSeach(pass)); }
         else{ showSearch(context: context, delegate: UserSearch(pass));}
      },
         child: Icon(Icons.add,
         size: 40,
         ),
         backgroundColor: const Color(0xffff5722),
         focusColor: Colors.white,
         ),
        ),
  ), 
   PositionedDirectional(
    top: (MediaQuery.of(context).size.height) * 0.43,
    start: (MediaQuery.of(context).size.width) * 0.60,
    child: 
        SizedBox(
      
      child:StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).utilisateursDonnees,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      UserData userData=snapshot.data;
                      print(userData.identifiant);
                      print('object');
                      print(_current_grp);
                      return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("groupe",_current_grp),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentAdmin = snapshot.data.data;
           print('object2');
           print(documentAdmin['admin'].toString() ==null ?" ": documentAdmin['admin'].toString()         );
           print(userData.identifiant);
           
           
          return
          FloatingActionButton(heroTag: 'btn10',onPressed:()=> { if (documentAdmin['admin']==userData.identifiant){creatAlertDialog(context),} else afficher_alerte(),},
         child: Icon(Icons.notification_important,
         size: 40,
         ),
         backgroundColor: const Color(0xffff5722),
         focusColor: Colors.white,
         );
        
          
           } else return Container();
    }));          
                           }else{
                      return Text('Loading');
                    }
                  }
              ),
        ),
  ),]
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
        if ((snapshot.hasData)&&(document['user']!='membreDefaut')) {
Map<String, dynamic> documentFields = snapshot.data.data;
        if(document['user']!=_current_userId){
             return  ListTile(
     leading: (
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.13,
                  height: (MediaQuery.of(context).size.height) * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${documentFields['image_url']}'
                      ),
                    ),
                  ),
                )
              ),  
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
      trailing: IconButton(icon: Icon(Icons.place,
      color : const Color(0xff339899)), onPressed: ()=>{
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: 
        LatLng(documentFields['latitude'],documentFields['longitude']),
        zoom: 16.0),)),
      }),
     onTap: ()=> _afficherMembre(documentFields),
    
       




                      );
        }else{
           return  ListTile(
     leading: (
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.13,
                  height: (MediaQuery.of(context).size.height) * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${documentFields['image_url']}'
                      ),
                    ),
                  ),
                )
              ),  
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
      subtitle: Text(
                'Vous',
                      style: const TextStyle(
                          color:  Colors.deepOrange,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 12.0
                      ),
                      textAlign: TextAlign.left                
                      ),
      trailing: IconButton(icon: Icon(Icons.place,
      color : const Color(0xff339899)), onPressed: ()=>{
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: 
        LatLng(documentFields['latitude'],documentFields['longitude']),
        zoom: 16.0),)),
      }),
     );
        }  
          
        }else{
          return Container();
        }
    }
)
       
       
       
       
       
       
     
                  );
  }
  creatAlertDialog( BuildContext context){
 return showDialog(context: context, builder:(context){
  return AlertDialog(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
  title : Text('Suggestions'),
  content:  Container(
              padding: EdgeInsets.symmetric(vertical:(MediaQuery.of(context).size.height) * 0.01, horizontal:(MediaQuery.of(context).size.width) * 0.01),
              height: (MediaQuery.of(context).size.height) * 0.4, // Change as per your requirement
      width: (MediaQuery.of(context).size.width) * 0.7,
     child: StreamBuilder(
     stream: Firestore.instance.collection('groupe').document(_current_grp).collection('suggestions').snapshots(),
     builder: (context,snapshot){
     if (!snapshot.hasData){ return const Text("aucune suggestion",
      style: const TextStyle(
      color:  const Color(0xff3d3d3d),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 17.0
  ),
  textAlign: TextAlign.left 
     );}
  else{ return  ListView.builder(
     itemExtent: 80.0,
     itemCount:snapshot.data.documents.length,
    itemBuilder: (ctx,index )=> (
    buildSugglistItem(ctx,snapshot.data.documents[index],_current_grp)),
      );}
     }
      ),
      
              
       ),
  actions: <Widget>[
    MaterialButton(
      elevation: 5.0,
      child: Text('Ignorer'),
      onPressed:() {
        Navigator.of(context).pop();
      },
     )
  ],

  );
 });

 }
  /*Affichage membre du groupe*/
_afficherMembre(Map<String, dynamic> document){

showModalBottomSheet(context: context, builder:(context){
     
      String url='assets/avatar.png';
      String phonenum = document['numtel'];
     print(phonenum);
     return Container(
        color: const Color(0xff737373),
       width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
        child: Container(
        decoration: BoxDecoration(
       color: const Color(0xffffffff),
        borderRadius:  BorderRadius.only(
          topLeft:  const Radius.circular(30) ,
          topRight:  const Radius.circular(30) ,
        ),
        ),
      child: Stack(children: [
  
     Container( 
      padding: EdgeInsets.only(
       
     top: (MediaQuery.of(context).size.height) * 0.05,
     bottom: (MediaQuery.of(context).size.height) * 0.02,
     left: (MediaQuery.of(context).size.width) * 0.04,
     right: (MediaQuery.of(context).size.width) * 0.04,
       ),
     child: ListView(children: [
       ClipOval(
                   child: SizedBox(
                     width: (MediaQuery.of(context).size.width) * 0.01,
                     height: (MediaQuery.of(context).size.height) * 0.1,
                     
                     child: Image.network(document['image_url'].toString(),fit: BoxFit.contain,)),
                     
                   ), 
                   SizedBox(height:(MediaQuery.of(context).size.height) * 0.02 ,),
                
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
    top: (MediaQuery.of(context).size.height) * 0.4,
    start:(MediaQuery.of(context).size.width) * 0.37,
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

 

void list_invitations(BuildContext context, String userID){
   showModalBottomSheet(context: context, builder:(context){
     return Container(
        color: const Color(0xff737373),
      
      width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,

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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.8,
      height: (MediaQuery.of(context).size.height) * 0.03,
      child: Text(
      "Invitations",
      style: const TextStyle(
          color:  const Color(0xde204f6f),
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          fontStyle:  FontStyle.normal,
          fontSize: 19.0
      ),
      textAlign: TextAlign.left                
      ),
      
      ),
      
  ),
     
     Container( 
     padding: EdgeInsets.only(
       
     top: (MediaQuery.of(context).size.height) * 0.075,
     bottom: (MediaQuery.of(context).size.height) * 0.02,
     left: (MediaQuery.of(context).size.width) * 0.04,
     right: (MediaQuery.of(context).size.width) * 0.04,
       ),
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
          fontSize: 17.0
      ),
      textAlign: TextAlign.left                
      ),
      Spacer(flex:1,),
       SizedBox(
       width: (MediaQuery.of(context).size.width) * 0.14,
       height: (MediaQuery.of(context).size.height) * 0.045,
            child: Text(  "à : "+ document['destination'],
                        style: const TextStyle(
                            color:  const Color(0xff52bf90),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                        ),
                        //textAlign: TextAlign.left,
                        ),
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
        String nom= 'Nom';
       String email= 'Email';
      String url='';//'https://www.cbronline.com/wp-content/uploads/2016/06/what-is-URL.jpg';
      String prenom = 'Prénom';
      String utilisateur = 'Pseudo';
       String phoneNumber="Numéro de téléphone";
       final FirebaseAuth _auth = FirebaseAuth.instance;
 
     return Container(
        color: const Color(0xff737373),
       width: (MediaQuery.of(context).size.width) * 0.360,
      height: (MediaQuery.of(context).size.height) * 0.535,
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
    top: (MediaQuery.of(context).size.height) * 0.035,
    start: (MediaQuery.of(context).size.width) * 0.1,
    child: 
        SizedBox(
      width: (MediaQuery.of(context).size.width) * 0.8,
      height: (MediaQuery.of(context).size.height) * 0.03,
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
    padding: EdgeInsets.only(
       
     top: (MediaQuery.of(context).size.height) * 0.075,
     bottom: (MediaQuery.of(context).size.height) * 0.02,
     left: (MediaQuery.of(context).size.width) * 0.04,
     right: (MediaQuery.of(context).size.width) * 0.04,
       ),
     child: ListView(children: [
                SizedBox(
                
                child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             mainAxisSize: MainAxisSize.min,

             
             children: <Widget>[
               Container(
                color: Colors.white24,
                height: (MediaQuery.of(context).size.height) * 0.03,
                width: (MediaQuery.of(context).size.width) * 0.1,
               ),
               Align(
                 alignment: Alignment.center,
                
                   child: ClipOval(
                   child: SizedBox(
                     width: (MediaQuery.of(context).size.width) * 0.16,
                     height: (MediaQuery.of(context).size.height) * 0.08,
                     
                     child: Image.network(_img,fit: BoxFit.fill,),
                     /*child:Image(
                  image: AssetImage('assets/avatar.png'),
                  fit: BoxFit.contain,
                ), */
                   ),
                   ),
                 
               ),
               Container(
                color: Colors.white24,
                height: (MediaQuery.of(context).size.height) * 0.03,
                width: (MediaQuery.of(context).size.width) * 0.1,
               ),
                
                     
             
             ]
           ),
              ),
                
                ListTile(
                  leading: Icon(Icons.person, color: Colors.greenAccent,),
                  title: Text(nom +" et " + prenom,
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
        url=userData.image_url;
        nom=userData.nom;
        prenom=userData.prenom;
        utilisateur=userData.identifiant;
        email=_email();
        return Container();
   }
     ),
     
     PositionedDirectional(
    top: (MediaQuery.of(context).size.height) * 0.07,
    start:(MediaQuery.of(context).size.width) * 0.27,
       child:  FlatButton(
         
         padding: EdgeInsets.only(top:(MediaQuery.of(context).size.height) * 0.35,left: (MediaQuery.of(context).size.width) * 0.06),
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
                 
buildSugglistItem(BuildContext ctx,DocumentSnapshot document,String idGroup) {
       return(  StreamBuilder<DocumentSnapshot>(
    stream: provideDocumentFieldStream("utilisateur",document['user']),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data;
           print(documentFields['identifiant']);
         
          return ListView(
            children :<Widget>[ ListTile(
              /*leading: (
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.13,
                  height: (MediaQuery.of(context).size.height) * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${documentFields['image_url']}'
                      ),
                    ),
                  ),
                )
              ),  */
       
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children : <Widget>[  Text(
                documentFields['identifiant'].toString(),
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
           
           )]);
   
           } 
           else { return Container();} }

           ));

                    }

_refuserSugg(String groupId,String docId) {
   Firestore.instance.collection('groupe').document(groupId).collection('suggestions').document(docId).delete().catchError((e){
   print(e);}); }

_accepterSugg(String docId,String grpID,String userID) {
            //ajouter linvitation à la liste d'invi de cet utilisateur
            Firestore.instance.collection('utilisateur').document(userID).collection('Invitations').document().setData({
                       'groupeID':_current_grp,
                      'admin': _current_grp_admin, 
                      'destination': _current_grp_destinaton, 
                      'groupe': _current_grp_name, 
            }).catchError((e){print(e);});
            
            //supprimer l'invitation
            Firestore.instance.collection('groupe').document(grpID).collection('suggestions').document(docId).delete().catchError((e){
              print(e);});
          }         
   

void updatePinOnMap(String id,String user) async {
   
   // create a new CameraPosition instance
   // every time the location changes, so the camera
   // follows the pin as it moves with an animation
          CameraPosition cPosition = CameraPosition(
   zoom: 16,
   tilt: 80,
   bearing: 30,
   target: LatLng(position.latitude,
      position.longitude),
   );
   
_controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
   
   setState(() {
 
      // updated position
      var pinPosition = LatLng(position.latitude,
     position.longitude);
      allMarkers.removeWhere(
      (m) => m.markerId.value == id);
      allMarkers.add(Marker(
         markerId: MarkerId(_current_userId),
         position: pinPosition, 
         icon: maleIcon,
           infoWindow: InfoWindow(
                        title: (user),
                        onTap:  ()=> _markerUserPressed(id),
                    ),
      ));
   });
}
    
}



