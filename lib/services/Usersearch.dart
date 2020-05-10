import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/screens/home/map.dart';



class UserSeach extends SearchDelegate<String> {
  //the hint text in search bar
  final searchFieldLabel = "Chercher un utilisateur";
  //json that we pass to show results to add the user to groupe
  var obj;
  var document;
  UserSeach(this.document);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
//stateful widget that turns green when added
//addd spinenr
    if (obj != null) {
      return Confirmation(
        obj: obj,
        dom: document);
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search),
            Text(' Aucun utlisateur'),
          ],
        ),
      );
    }
    ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //method that checks if there is profile image to show in suggestions
    //else it shows an icon of person

    Widget leading(AsyncSnapshot url, int index) {
      if (url.data.documents[index]["image_url"] == "") {
        return Icon(Icons.person);
      } else {
        return CircleAvatar(
          backgroundImage: NetworkImage(url.data.documents[index]["image_url"]),
        );
      }
    }

    if (query != "") {
      return Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('utilisateur')
              .where("nom", isEqualTo: query)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 6.5),
                    child: Material(
                      color: Colors.deepOrange[50],
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Colors.grey[900],
                      elevation: 15,
                      child: ListTile(
                        onTap: () {
                          obj = snapshot.data.documents[index];
                          query = obj["identifiant"];
                          showResults(context);
                        },
                        leading: leading(snapshot, index),
                        title:
                            Text(snapshot.data.documents[index]["identifiant"]),
                        subtitle:
                            Text(snapshot.data.documents[index]["prenom"]),
                      ),
                    )),
                itemCount: snapshot.data.documents.length,
              );
            }
          },
        ),
      );
    } else {
      //create widget that retuns text and icon
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              size: 30,
              color: Colors.grey,
            ),
            Text(
              "Vide",
              style: TextStyle(
                color: Colors.grey,
               fontSize: 18,
               ),
            ),
          ],
        ),
      );
    }
  }
}

class Confirmation extends StatefulWidget {
 final obj;
 final dom;
 
 const Confirmation ({ Key key, this.obj ,this.dom}): super(key: key);

  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
dynamic botton ;
bool ay = true ;
Color green = Colors.teal;
Color  col = Colors.grey[350] ;


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(20),
        ),
        child:Column(
          mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
           CircleAvatar(
                  backgroundImage: NetworkImage(widget.obj["image_url"]),
                ),
          SizedBox(
            width: 15,
          ),
           Text.rich(
                  TextSpan(
                    text: widget.obj["identifiant"],
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  )
          ],
        ),
         SizedBox(
              height:10
            ),
        Row(
          children: <Widget>[
           SizedBox(
             width: 60
           ),
           Text.rich(
                  TextSpan(
                    text: widget.obj["nom"],
                ),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  letterSpacing: 1
                ),
                ),
          ],
        ),
        SizedBox(
          height: 40
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            botton = ay ?  RaisedButton(onPressed:() {
              
              Firestore.instance.collection('utilisateur').document((widget.obj["uid"]).toString()).collection('Invitations').document().setData({
                     'groupeID':widget.dom["groupeID"].toString(),
                      'admin': widget.dom["admin"].toString(), 
                      'destination': widget.dom["destination"].toString(), 
                      'groupe': widget.dom["groupe"].toString(),                  
                      
                  });
               setState(() {
                col = green;
                ay = false;
                
              });
            },
            padding: EdgeInsets.all(20),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            child: Text("Inviter '${widget.obj["identifiant"]}' au groupe",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15
            ),
            ),
            ) : Container(
              child:Row(
                children: <Widget>[
                    Icon(Icons.done ,size: 40, color: Colors.white,),
                    Text("Invitation a été envoyée", style: TextStyle(fontSize: 20, color: Colors.white), )
                ],
                ),
            ),
          ],
        ),
      ]
    ),
    );
  }
}