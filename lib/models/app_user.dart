import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{

  final String username;
  final  String email;

  final  String photoURL;


  AppUser({this.email,this.username,this.photoURL});

  factory AppUser.fromDocument(DocumentSnapshot doc,String email){
    String photo=doc['photoURL'];
   try{
     if(doc['photoURL']==null){
       photo=doc['photoUrl'];
     }else{
       photo= doc['photoURL'];
     }
   }catch(e){
     print(e.toString());
   }

    return AppUser(
      email   :email,
      photoURL  :photo ,
      username  :doc['username'],
    );
  }

  @override
  String toString() {
    return 'AppUser{username: $username, email: $email, photoURL: $photoURL}';
  }
}