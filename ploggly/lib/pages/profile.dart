import 'package:flutter/material.dart';
import 'package:ploggly/widgets/header.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header("profile"),
    );
  }
}