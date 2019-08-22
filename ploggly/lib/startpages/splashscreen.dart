import 'package:flutter/material.dart';
import 'package:ploggly/firstimepages/steponepage.dart';

import 'login.dart';



void main() => runApp(SplashScreenApp());

class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
 
    super.initState();
    Future.delayed(Duration(
      seconds: 3
      ),(){

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpOnePage()));
       
     },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child:Text('ploggly.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Pacifico',
                fontSize: 35.0,
              ),

              ),
            ),
            SizedBox(height: 15.0,),
            Center(
              child:Text('share yourself to the world',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 10.0,
              ),

              ),
            ),
          ],
        ),
    );
  }
}