import 'package:flutter/material.dart';
import 'package:ploggly/widgets/header.dart';
import 'home.dart';

class Timeline extends StatefulWidget {
 
  @override
  _TimelineState createState() => _TimelineState();
  
}

class _TimelineState extends State<Timeline> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: header("ploggly"),
    );
  }
}