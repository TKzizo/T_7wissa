import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';
<<<<<<< Updated upstream


class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/creationGroupe.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String _selectedItem = '';
  final _formKey = GlobalKey<FormState>(); //pour identifier le formulaire 
  // text field state
  String nom = '';
  String lieu = '';
  String error =''; 
  String heure ='';
  List<dynamic> listMembre = null;
  String admin = '';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

>>>>>>> Stashed changes

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {


final AuthService _auth = AuthService();
  final databaseReference = Firestore.instance;
<<<<<<< Updated upstream

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
=======
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
>>>>>>> Stashed changes
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


Widget _child(){
        return  Container(

<<<<<<< Updated upstream

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

=======
          child: Scaffold(
           key: _scaffoldKey,
            backgroundColor: Colors.white,    
            body:  GoogleMap(
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,)
                      
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
      ),
      /*MENU*/

      body: SlidingUpPanel(
       backdropEnabled: true,
      panelBuilder: (ScrollController sc) => _scrollingList(sc),
      body: _child(),
      borderRadius: radius ,
      ), 
        bottomNavigationBar: BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.free_breakfast), onPressed: () {},),
          IconButton(icon: Icon(Icons.message), onPressed: ()=> _onButtonPressed(),),
          IconButton(icon: Icon(Icons.group ), onPressed: () =>_onGroupButtonPressed(),),
          IconButton(icon: Icon(Icons.place), onPressed: () {},),
        ],
      ),
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


>>>>>>> Stashed changes


      body: _child,
    );
  }
<<<<<<< Updated upstream
}
=======



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
  // ✏️ Headline 6 
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
    _buildGrouplistItem(ctx,snapshot.data.documents[index])),
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
      child: SingleChildScrollView(
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
                   hintText: 'Destination',
                   suffixIcon: Icon (
                              Icons.search, 
                              color : Color(0xffff5722),
                          ),
                    ),
                  validator: (val) => val.isEmpty  ? 'Choisissez une destination' : null,
                  onChanged: (val) {
                    setState(() => lieu = val);
                  },
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: const InputDecoration(
                   hintText: 'Heure de départ',
                    ),
                  validator: (val) => val.isEmpty ? 'Donnez une heure de départ' : null,
                  onChanged: (val) {
                    setState(() => heure = val);
                  },
                ),
                Row(
                   children: <Widget>[
                     SizedBox(height: 80,),
                     SizedBox(width: 70,),
                     FlatButton.icon(
                       icon: Icon(Icons.add_circle,color: Color(0xffff5722), size: 40,),
                       label: Text("Ajoutez les membres"),
                       onPressed: () => print(nom)
                      ),
                    ],      
                ),
                
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepOrange,
                  child: 
                  MaterialButton(
                  minWidth: 174,
                  height: 36,
                  child: 
                  Text("Créer le groupe",
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
      ),
      )
     );
    }
    );
    
  }




     _buildGrouplistItem(BuildContext ctx,DocumentSnapshot document) {
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
     Text(
                      "à : "+ document['destination'],
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
         
      ) ) , ]) ), );
        }
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
  
/*LISTE DES MESSAGES A ENVOYER*/


}
>>>>>>> Stashed changes
