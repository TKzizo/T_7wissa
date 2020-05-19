/*Notification des messages*/

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MsgHandler extends StatefulWidget {
  MsgHandler({Key key}) : super(key: key);
  List <Map<String , dynamic>> table =[];


  @override
  _MsgHandlerState createState() => _MsgHandlerState();
}

class _MsgHandlerState extends State<MsgHandler> {


final Firestore _ins = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();


  
    
  

  @override
  Widget build(BuildContext context) {
    
    _fcm.configure(
      onMessage: (Map<String , dynamic> message) async {
        setState(() {
          var msg = {"notification":{"title":message["notification"]["title"],
          "body":message["notification"]["body"],
          "ps":message["notification"]["ps"]}};
          widget.table.add(msg);
        });
        
        final snack = SnackBar(content: Text("nouvelle notification"),
        action: SnackBarAction(
          label: "ok" ,
          onPressed: () => null,),
          elevation: 10.0,
          );
          Scaffold.of(context).showSnackBar(snack);   
      },

      onLaunch: (message) async {
         widget.table.add(message);
      },

      onResume: (message) async {
         widget.table.add(message);
      },

    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        elevation: 3.0,
        leading: IconButton(icon: Icon(Icons.arrow_back), 
        onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => widget.table.length >=1 ? Container(
                    margin: EdgeInsets.symmetric(vertical: 6.5),
                    child: Material(
                      color: Colors.deepOrange[50],
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Colors.grey[900],
                      elevation: 15,
                      child: ListTile(
                        leading:Icon(Icons.textsms,color:Colors.orange),
                        title:
                            Text(widget.table[index]["notification"]["title"]),
                        subtitle:
                            Text(widget.table[index]["notification"]["body"]),
                        onTap:() {
                          widget.table.removeAt(index);
                        } ,
                      ),
                    )):Center(child:Text('vide')),
                itemCount: widget.table.length,
              ),
    );
  }

}