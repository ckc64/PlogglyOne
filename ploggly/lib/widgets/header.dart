import 'package:flutter/material.dart';

AppBar header(String title){
  return AppBar(
      title:Text(
        title,
        style: TextStyle(
          color:Colors.white,
          fontFamily: 'Pacifico',
          fontSize: 25.0
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.pink,
  );
}