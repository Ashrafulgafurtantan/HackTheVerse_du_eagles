import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/ui/home.dart';
import 'package:firebase_auth_gorgeous_login/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}
class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

   final  appGuard = Provider.of<AppGuard>(context);
    if(appGuard==null ){
      return LoginPage();
    }else{
      return appGuard.isVerified ? Home(appGuard: appGuard,):LoginPage();
    }
  }
}
