import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Shared{

 final emailRegExp= RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');


 Gradient getGradient(Color start,Color end){
  var gradient=new LinearGradient(
      colors: [
       start,
       end
      ],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

    return gradient;
 }
}