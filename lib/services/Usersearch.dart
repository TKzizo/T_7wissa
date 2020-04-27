import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserSeach extends SearchDelegate<String> {
  //the hint text in search bar
  final searchFieldLabel = "Chercher un utilisateur";
  //json that we pass to show results to add the user to groupe
  var obj;

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
      return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey[350],
             borderRadius: BorderRadius.circular(20),
             ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(obj["image_url"]),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height:5),
                Text.rich(
                  TextSpan(
                    text: obj["identifiant"],
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: obj["nom"],
                ),
                style: TextStyle(
                  fontSize: 15,
                ),
                ),
                SizedBox(height: 95),
                RaisedButton.icon(icon: Icon(Icons.add), label: Text("Ajouter au groupe"),onPressed: (){
                  
                  Firestore.instance.collection('utilisateur').document((obj["uid"]).toString()).collection('Invitations').document().setData({
                      'groupeID':'1314',
                      'admin': 'ammalimouna', 
                      'destination': 'Alger', 
                      'groupe': 'Famille', 
                      
           
                      
                  });
                  },)
              ],
            ),
          ],
        ),
      );
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

    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('utilisateur')
            .where("identifiant", isEqualTo: query)
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
                  )
                  ),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }
}

