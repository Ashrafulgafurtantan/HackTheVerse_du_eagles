import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:flutter/material.dart';
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(onPressed: (){
        googleSignIn.signOut();
        authService.signOut();
      }, child: Container(
        height: 40,
        width: 100,
        color: Colors.pinkAccent,
        child: Center(child: Text("SignOut",style: TextStyle(color: Colors.white),)),
      )),
    );
  }
}
