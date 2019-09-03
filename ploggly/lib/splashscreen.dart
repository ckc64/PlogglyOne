import 'package:flutter/material.dart';
import 'package:ploggly/pages/home.dart';

import 'loginpages/ui/login_page.dart';


class SplashScreenFull extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenFull> {

  @override
  void initState() {
 
    super.initState();
    Future.delayed(Duration(
      seconds: 3
      ),(){

       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
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