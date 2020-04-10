import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

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
               floatingActionButton: FloatingActionButton(
                child: Icon(Icons.location_searching,),
                onPressed: () {
                  getCurrentLocation();
                },
                backgroundColor: Colors.deepOrangeAccent,
          ),
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
        title: Text('Home'),

      )  ,
      /*MENU*/
        bottomNavigationBar: BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.free_breakfast), onPressed: () {},),
          IconButton(icon: Icon(Icons.message), onPressed: ()=> _onButtonPressed(),),
          IconButton(icon: Icon(Icons.group ), onPressed: () {},),
          IconButton(icon: Icon(Icons.place), onPressed: () {},),
        ],
      ),
    ),
      body:   SlidingUpPanel(
       backdropEnabled: true,
      panelBuilder: (ScrollController sc) => _scrollingList(sc),
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
    );




  }
_buildlistItem(BuildContext ctx,DocumentSnapshot document) {
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
  Widget _scrollingList(ScrollController sc){
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
void _onButtonPressed(){
   
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
    _buildlistItem(ctx,snapshot.data.documents[index])),
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

}
