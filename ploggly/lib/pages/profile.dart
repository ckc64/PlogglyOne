import 'package:flutter/material.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ploggly/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileID;

  const Profile({Key key, this.profileID}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {

FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

 final userRef = Firestore.instance.collection('users');

buildProfileHeader(){
  return FutureBuilder(
    future: userRef.document(widget.profileID).get(),
    builder: (context,snapshot){
      if(!snapshot.hasData){
          return circularProgress();
      }
      //final user = userRef.document(widget.profileID).snapshots();
      return Center(child: Text(snapshot.data['bio'],style: TextStyle(color: Colors.black,fontSize: 35),));
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header("profile"),
        body: ListView(
          children: <Widget>[
              buildProfileHeader()
          ],
        ),
    );
  }
}


