import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:flutter/material.dart';

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(child: Center(child: Text("Doctor")),),
        Container( height: 50,width: 120,color: Colors.amber,
          child: MaterialButton(onPressed: (){
            authService.signOut();
            googleSignIn.signOut();
          },
            child: Text("SignOut"),
          ),
        )
      ],
    );
  }
}
