import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {



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
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude,position.longitude),
          zoom: 12.0
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
      },
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