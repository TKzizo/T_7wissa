import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

//this is an old version
class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {


final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController _controller;
  Position position;
  Widget _child;


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
      _child = _mapWidget();
    });
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

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  Widget _mapWidget(){
              final user = Provider.of<User>(context);


        return  Container(
          child: Scaffold(
           key: _scaffoldKey,
            backgroundColor: Colors.white,
                       
            /*Bar*/ 
                    appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0.0,
          title: Text('Home'),
          
        )  , 
            /*MENU*/ 
            
            body: GoogleMap(
                        mapType: MapType.normal,
                        markers: _createMarker(),
                        initialCameraPosition: CameraPosition(
                            target: LatLng(position.latitude,position.longitude),
                            zoom: 12.0
                        ),
                        onMapCreated: (GoogleMapController controller){
                          _controller = controller;
                        },
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
                      )
                      
        ); 
      
    
  }




  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(position.latitude,position.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Je suis là'))
    ].toSet();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: _child,
    );
  }
}