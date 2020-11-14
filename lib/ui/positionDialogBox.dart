import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/style/shared.dart';
import 'package:firebase_auth_gorgeous_login/style/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PositionDialogBox extends StatefulWidget {

  @override
  _PositionDialogBoxState createState() => _PositionDialogBoxState();
}

class _PositionDialogBoxState extends State<PositionDialogBox> {
  int result = 0;

  changeResult(val){

    setState(() {
      result = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 7.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetAnimationCurve: Curves.bounceInOut,
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: [
          Container(
            height: 250,
            width: 300,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              gradient: Shared().getGradient(Theme.Colors.loginGradientEnd,Theme.Colors.loginGradientStart),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RadioListTile(
                        value: 1,
                        title: Text("Doctor", style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),),
                        groupValue: result,
                        activeColor: Colors.pinkAccent,
                        onChanged: changeResult

                      ),
                      RadioListTile(
                        title: Text("Patient", style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),),
                        value: 2,
                        groupValue: result,
                        activeColor: Colors.pinkAccent,
                        onChanged: changeResult
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 30,
            child: Container(
              alignment: Alignment.center,
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Shared().getGradient(Theme.Colors.loginGradientStart, Theme.Colors.loginGradientEnd,)
              ),
              child: IconButton(
                onPressed: ()async{
                  Navigator.pop(context, result);
                },
                highlightColor: Colors.transparent,
                splashColor: Theme.Colors.loginGradientEnd,
                alignment: Alignment.center,
                icon: Icon(Icons.send,size: 37,color: Colors.white,),

              ),
            ),
          ),
          Positioned(
              top:-50,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/img/login_logo.png',fit: BoxFit.cover,),
                ),
              ))
        ],
      ),

    );
  }
}