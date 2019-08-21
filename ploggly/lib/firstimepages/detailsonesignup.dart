
import 'package:flutter/material.dart';

class SignUpOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpOnePage()
    );
  }
}

class SignUpOnePage extends StatefulWidget {
  @override
  _SignUpOnePageState createState() => _SignUpOnePageState();
}

class _SignUpOnePageState extends State<SignUpOnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Text('LOG IN')
      ),
    );
  }
}

