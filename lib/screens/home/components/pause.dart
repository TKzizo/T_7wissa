import 'package:flutter/material.dart';

class Pauseconfirmation  {
 
 void _onBreakConfirmationPressed(context){
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
  
  }


    
