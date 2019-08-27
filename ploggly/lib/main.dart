import 'package:flutter/material.dart';
import 'package:ploggly/loginpages/ui/firsttime_page.dart';
import 'package:ploggly/loginpages/ui/login_page.dart';
import 'package:ploggly/splashscreen.dart';



void main() => runApp(MyApp());

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
  @override
  Widget build(BuildContext context) {
    return FirsTimePage();
  }
}
