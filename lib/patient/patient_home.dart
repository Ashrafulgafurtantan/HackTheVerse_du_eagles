import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:flutter/material.dart';

class PatientHome extends StatefulWidget {
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: Center(child: Text("Patient")),),
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
