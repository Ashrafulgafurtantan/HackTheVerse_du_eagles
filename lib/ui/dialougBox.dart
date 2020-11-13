import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/style/shared.dart';
import 'package:firebase_auth_gorgeous_login/style/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DialogWidget extends StatelessWidget {
  const DialogWidget({
    Key key,
    @required this.resendEmailController,
  }) : super(key: key);

  final TextEditingController resendEmailController;

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
                  height: 80,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 7),
                    child: TextField(

                      autofocus: false,
                      controller: resendEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.black,
                          size: 22.0,
                        ),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize:17.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 50,
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
                  String email =resendEmailController.text;
                  if(Shared().emailRegExp.hasMatch(email)){
                    await authService.resetPassword(email);
                    resendEmailController.clear();
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                  }
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