/*Définition de l'id du user*/
class User {
  final String uid; 
  
  User({this.uid});
   
}

/*Les attributs de la classe UserData*/
class UserData{
  final String uid; 
  final String nom; 
  final String prenom; 
  final String numtel; 
  final String identifiant; 
  final double longitude; 
  final double latitude; 
  final double vitesse; 
  final String image_url; 
  UserData({this.uid, this.nom, this.identifiant,
   this.prenom, this.numtel,this.latitude,this.longitude,this.vitesse,this.image_url});
}