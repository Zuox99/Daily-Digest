import 'package:flutter/material.dart';

TextStyle appbarText = new TextStyle(
    fontSize: 25,
    color: Colors.black87,
    fontFamily: 'Times',
    fontWeight: FontWeight.bold
);

BoxDecoration background = new BoxDecoration(
//              color: Colors.black.withOpacity(0.5),
  image: DecorationImage(
      image: AssetImage('assets/wallpaper3.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.15), BlendMode.multiply)),
);