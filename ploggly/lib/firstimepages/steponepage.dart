
import 'package:flutter/material.dart';
import 'progressStepCircle.dart';

class SignUpOnePage extends StatefulWidget {
  @override
  _SignUpOnePageState createState() => _SignUpOnePageState();
}





class _SignUpOnePageState extends State<SignUpOnePage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Row(children: <Widget>[
           StepCircle(txt: '10',
           padL: 25,
           padT: 25,
           padR: 25,
           padB: 30),
           
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape:BoxShape.rectangle,
              color: Colors.green
            ),
          )
            
        ],)
      ],)
    );
  }
}
