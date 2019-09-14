import 'package:flutter/material.dart';
import 'package:ploggly/loginpages/ui/login_page.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_){
    print("Timestamps enable in snapshots\n");
  }, onError: (_){
    print("Error in timestamp snapshot");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:     Brightness.light,
        primaryColor:   Colors.pink,
        accentColor:    Colors.red,
        fontFamily: 'Montserrat'
      ),
        home: MainApp()
    );
  }
}
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  
  String email="",uid="",password="";
  bool isLoggedIn=false;
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("email") != null && prefs.getString("uid") !=null && prefs.getString("password") !=null) {
        email = prefs.getString("email");
        uid = prefs.getString("uid");
        password = prefs.getString("password");
        print("$email,$uid,$password");
        
        setState(() {
              isLoggedIn = true;
        });
      }else{
        setState(() {
          isLoggedIn = false; 
        });
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn ? Homepage(userID: uid,): SplashScreenFull()

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _function();
    
  }
}
