import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class FloatToast {


  Future floatToast(String message){
   return  Fluttertoast.showToast(
        msg: message,//"Invalid email or password!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 2,

        backgroundColor: Colors.white70,
        textColor: Colors.pinkAccent,
        fontSize: 16.0);

  }
}
