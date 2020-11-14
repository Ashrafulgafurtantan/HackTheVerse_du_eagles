import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth_gorgeous_login/doctor/doc_home.dart';
import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/models/app_user.dart';
import 'package:firebase_auth_gorgeous_login/patient/patient_home.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  final AppGuard appGuard;
  Home({this.appGuard});
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  getCurrentUser()async{
   DocumentSnapshot doc =await userRef.doc(widget.appGuard.email).get();//.....
    thisDeviceAppUser = AppUser.fromDocument(doc,doc.id);//...
    print("thisDeviceAppUser = $thisDeviceAppUser");
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: thisDeviceAppUser.account==1? DoctorHome(): PatientHome()

    );
  }
}
