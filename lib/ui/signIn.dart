import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_gorgeous_login/main.dart';
import 'package:firebase_auth_gorgeous_login/models/app_user.dart';
import 'package:firebase_auth_gorgeous_login/style/shared.dart';
import 'package:firebase_auth_gorgeous_login/style/theme.dart' as Theme;
import 'package:firebase_auth_gorgeous_login/ui/dialougBox.dart';
import 'package:firebase_auth_gorgeous_login/ui/flutter_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
final GoogleSignIn googleSignIn=GoogleSignIn();
final userRef = FirebaseFirestore.instance.collection("users");
AppUser thisDeviceAppUser ;

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool passwordValid=true;
  bool emailValid=true;

  void _toggleLogin() {
    setState ( () {
      _obscureTextLogin = !_obscureTextLogin;
    } );
  }

  createAccountInCloudFireStoreUsingGoogleSignin(googleSignInAccount)async{
    print("createAccountInCloudFireStore = $googleSignInAccount");
    await userRef.doc(googleSignInAccount.email).set({
      "displayName": googleSignInAccount.displayName,
      "emailVerified" : true,
      'photoURL' : googleSignInAccount.photoUrl,
      "username":googleSignInAccount.displayName,
      'email': googleSignInAccount.email,
    });
  }
  googleSignInMethod()async{
try{
  GoogleSignInAccount googleSignInAccount= await  googleSignIn.signIn();
  if(googleSignInAccount!=null){
    GoogleSignInAuthentication googleSignInAuthentication= await   googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(idToken:googleSignInAuthentication.idToken , accessToken: googleSignInAuthentication.accessToken);
    final result = await authService.signInWithGoogle(credential);
    if(result!=null){
      GoogleSignInAccount googleSignInAccount  = googleSignIn.currentUser;
      DocumentSnapshot doc =await userRef.doc(googleSignInAccount.email).get();
      if(doc.exists){
        print("u already have an account");
        await userRef.doc(googleSignInAccount.email).update({
          "displayName": googleSignInAccount.displayName,
          "emailVerified" : true,
          'photoURL' : googleSignInAccount.photoUrl,
          "username":googleSignInAccount.displayName,
          "email" : googleSignInAccount.email,
        });

      }else{
        await createAccountInCloudFireStoreUsingGoogleSignin(googleSignInAccount);
      }
    }
  }
}catch(e){
  print(e.toString());
}
  }
  updateEmailVerificationValue(String email)async{
    await userRef.doc(email).update({
      'emailVerified':true,
    });

  }

  connectWithFirebaseAuthEmailPassword(String email,String password)async{
    final result = await authService.signInWithEmailAndPassword(email, password);//Result = Firebase User
        print("in SignIn");
      if(result==null){
        print("Email or passwor  e jhamela...");
        FloatToast().floatToast("Invalid email or password!!!");
      }else{
        if(result.emailVerified){
          print("Email verified");
         await updateEmailVerificationValue(email);
          DocumentSnapshot doc = await userRef.doc(result.email).get();//..........
          thisDeviceAppUser = AppUser.fromDocument(doc,doc.id);//.......


        }else{
          print("email Not verified");
          FloatToast().floatToast("Please verify your email ");
        }
      }
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
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          autofocus: false,
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: emailValid? Colors.black: Colors.red,
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize:17.0),
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
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color:passwordValid? Colors.black:Colors.red,
                            ),
                            hintText:  "Password(6+ char)",

                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize:  17.0,),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
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
                margin: EdgeInsets.only(top: 170.0),
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
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child:  MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async{
                      print("Hello login");
                      print(loginEmailController.text);
                      print(loginPasswordController.text);
                      setState(() {
                        emailValid = Shared().emailRegExp.hasMatch(loginEmailController.text);

                      });
                      setState(() {
                        passwordValid = loginPasswordController.text.length>5 && loginPasswordController.text !=null;
                      });
                      print(emailValid);
                      print(passwordValid);

                      if(emailValid && passwordValid){
                        connectWithFirebaseAuthEmailPassword(loginEmailController.text,loginPasswordController.text);
                      }

                    }

                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  showDialog(context: context,builder: (context){
                    TextEditingController resendEmailController=TextEditingController();
                    return DialogWidget(resendEmailController: resendEmailController);
                  });
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: googleSignInMethod,
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/*MaterialButton(
                          onPressed:(){} ,
                          highlightColor: Colors.transparent,
                          splashColor: Theme.Colors.loginGradientEnd,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontFamily: "WorkSansBold"),
                            ),
                          ),
                        ),*/