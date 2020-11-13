import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/services/auth.dart';
import 'package:firebase_auth_gorgeous_login/ui/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
AuthService authService=AuthService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamProvider<AppGuard>.value(
      value: authService.user,
      child: MaterialApp(
        title: 'TheGorgeousLogin',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}