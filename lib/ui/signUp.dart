import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/style/shared.dart';
import 'package:firebase_auth_gorgeous_login/ui/positionDialogBox.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth_gorgeous_login/style/theme.dart' as Theme;
import 'package:firebase_auth_gorgeous_login/ui/flutter_toast.dart';

import '../main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  bool nameValid=true;
  bool confirmPasswordValid=true;
  bool passwordValid=true;
  bool emailValid=true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();
  var position;
  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  createAccountInCloudFireStoreUsingEmailPasswordLogin(result,String name)async{// Change ashbe
    print("createAccountInCloudFireStore = $result");
    await userRef.doc(result.email).set({
      'account':position,//1 = doc,2=patient
      "displayName": name,
      "emailVerified" : result.emailVerified,
      'photoURL' : result.photoURL,
      "username":name,
      'email' : result.email,
    });
  }

 Future<bool> connectWithFirebaseAuthEmailPassword(String email,String password,String name)async{
    print("email =$email, name= $name");
    final result = await authService.signUpWithEmailAndPassword(email, password);//Result = Firebase User
    if(result==null){
      print("In signUp emal e jhamela.ALREADY USED ");
      FloatToast().floatToast("This mail already had an account");
      return false;
    }else{
      print("In signup class ");
        await  createAccountInCloudFireStoreUsingEmailPasswordLogin(result,name);//Change ashbe
      FloatToast().floatToast("Account created.Email verification is necessary for Log in");
      return true;
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color:nameValid? Colors.black: Colors.red,
                            ),
                            hintText: "Name(3+ Char)",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color:emailValid? Colors.black: Colors.red,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black

                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color:passwordValid? Colors.black:Colors.red,
                            ),
                            hintText: "Password(6+ Char)",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color:confirmPasswordValid? Colors.black:Colors.red,
                            ),
                            hintText: "Confirmation",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 340.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: Shared().getGradient(Theme.Colors.loginGradientEnd,Theme.Colors.loginGradientStart),

                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: ()async {
                      print("Hello signup");
                      setState(() {
                        nameValid=signupNameController.text.length>2;
                        emailValid =Shared().emailRegExp.hasMatch(signupEmailController.text);
                      });
                      setState(() {
                        passwordValid = signupPasswordController.text.length>5 && signupPasswordController.text !=null;
                        confirmPasswordValid=signupConfirmPasswordController.text==signupPasswordController.text;
                      });
                      if(nameValid&& emailValid && passwordValid && confirmPasswordValid){

                        position = await showDialog(
                          context: context,
                          child: PositionDialogBox()
                        );
                        print(position);

                       bool clearCredencials = await connectWithFirebaseAuthEmailPassword(signupEmailController.text,signupPasswordController.text,signupNameController.text);
                        if(clearCredencials){
                          signupNameController.clear();
                          signupEmailController.clear();
                          signupPasswordController.clear();
                          signupPasswordController.clear();
                          signupConfirmPasswordController.clear();
                        }
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
