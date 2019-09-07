import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/activity_feed.dart';
import 'package:ploggly/pages/profile.dart';
import 'package:ploggly/pages/search.dart';
import 'package:ploggly/pages/timeline.dart';
import 'package:ploggly/pages/upload.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';




class Homepage extends StatefulWidget {

  final String userID;
  Homepage({Key key,this.userID}) : super(key: key);

  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  PageController pageController;
  int pageIndex =0;
  //  void getCurrentUser() async{
  //       final user = await fAuth.currentUser();
  //       if(user != null){
  //         loggedInUser = user;
  //       }

  //   }

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

      setState(() {
         switch (pageIndex) {
           case 0:
                isTimeLine=true;
                break;
            case 1:
                isTimeLine=false;
                break;
            case 2:
                isTimeLine=false;
                break;
            case 3:
                isTimeLine=false;
                break;
            case 4:
                isTimeLine=false;
                break;
           default:
         }
      });

        print(isTimeLine);
         print(pageIndex);
      
     
  }
bool isTimeLine=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(profileID: widget.userID),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        //physics: NeverScrollableScrollPhysics(),
      ),
      
      bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 25,color: Colors.white,),
            Icon(Icons.whatshot, size: 25,color: Colors.white),
            Icon(Icons.camera_alt, size: 25,color: Colors.white),
            Icon(Icons.search, size: 35,color: Colors.white),
            Icon(Icons.favorite, size: 25,color: Colors.white),
          ],
          color: Colors.pink,
          
          buttonBackgroundColor: Colors.pink,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: onTap,
        ),
      
      
      
      
      // CupertinoTabBar(
      //     currentIndex: pageIndex,
      //     onTap: onTap,
      //     //backgroundColor: isTimeLine ? Colors.transparent : Colors.white,
      //     activeColor: Colors.pink,
      //     items: [
      //       BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
      //       BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
      //       BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size:35.0)),
      //       BottomNavigationBarItem(icon: Icon(Icons.search)),
      //       BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
      //     ],
      // ),
      
    );

  }

  Scaffold authScreen(){
    return Scaffold(
        
    );
  }
}