import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/activity_feed.dart';
import 'package:ploggly/pages/profile.dart';
import 'package:ploggly/pages/search.dart';
import 'package:ploggly/pages/timelime.dart';
import 'package:ploggly/pages/upload.dart';




class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  PageController pageController;
  int pageIndex =0;
   void getCurrentUser() async{
        final user = await fAuth.currentUser();
        if(user != null){
          loggedInUser = user;
        }

    }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex; 
    });
  }

  onTap(int pageIndex){
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Colors.pink,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size:35.0)),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ],
      ),
      
      

    );

  }

  Scaffold authScreen(){
    return Scaffold(
        
    );
  }
}