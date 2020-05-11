import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MsgHandler extends StatefulWidget {
  MsgHandler({Key key}) : super(key: key);


  @override
  _MsgHandlerState createState() => _MsgHandlerState();
}

class _MsgHandlerState extends State<MsgHandler> {
List <Map<String , dynamic>> tab = [];
final Firestore _ins = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

@override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String , dynamic> message) async {

        tab.add(message);
        final snack = SnackBar(content: Text("nouvelle notification"),
        action: SnackBarAction(
          label: "ok" ,
          onPressed: () => null,)
          );
          Scaffold.of(context).showSnackBar(snack);   
      },

      onLaunch: (message) async {
         tab.add(message);
      },

      onResume: (message) async {
         tab.add(message);
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        leading: IconButton(icon: Icon(Icons.arrow_back), 
        onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 6.5),
                    child: Material(
                      color: Colors.deepOrange[50],
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Colors.grey[900],
                      elevation: 15,
                      child: ListTile(
                        leading:Icon(Icons.stop) ,
                        title:
                            Text(tab[index]["notification"]["title"]),
                        subtitle:
                            Text(tab[index]["notification"]["body"]),
                      ),
                    )),
                itemCount: tab.length,
              ),
    );
  }

}