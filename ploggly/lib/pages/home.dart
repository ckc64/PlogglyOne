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
import 'package:ploggly/pages/user.dart';
import 'package:ploggly/pages/worldtimeline.dart';



FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final userRef = Firestore.instance.collection('users');
  User currentUser;
  DocumentSnapshot doc;
  final followersRef = Firestore.instance.collection('followers');
  final followingRef = Firestore.instance.collection('following');
   final activityFeedRef = Firestore.instance.collection('feed');
   final timelineRef = Firestore.instance.collection('timeline');
class Homepage extends StatefulWidget {
 
  final String userID;
  Homepage({Key key,this.userID}) : super(key: key);

  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   

  int currentPageIndex;
  int lastPageIndex;
 

  PageController pageController;
  int pageIndex =0;
   void getCurrentUser() async{
        final user = await fAuth.currentUser();
        if(user != null){
          loggedInUser = user;
         doc = await userRef.document(loggedInUser.uid).get();
         setState(() {
            currentUser = User.fromDocument(doc);
         });
          
         
        }
 
    }

    

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    //pageIndex = 0;
    //currentPageIndex = 0;
   
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
                currentPageIndex = pageIndex;
                isTimeLine=true;    
                break;
            case 1:
            currentPageIndex = pageIndex;
                isTimeLine=false;
                break;
            case 2:
            currentPageIndex = pageIndex;
                isTimeLine=false;
                break;
            case 3:
            currentPageIndex = pageIndex;
                isTimeLine=false;
                break;
            case 4:
            currentPageIndex = pageIndex;
                isTimeLine=false;
                break;
           default:
         }


         print("Curr : $currentPageIndex");
         print("Last Page : $lastPageIndex");
      });
        
  
      
     
  }
bool isTimeLine=true;

Future<bool> _onBackPressed(){
  
}

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      body: WillPopScope(
        onWillPop: _onBackPressed,
              child: PageView(
          children: <Widget>[
            WorldTimeline(currentUser: widget.userID,),
            Timeline(currentUser:widget.userID),
            ActivityFeed(),
            Upload(currentUser: widget.userID),
            Search(),
            Profile(profileID: widget.userID),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          //physics: NeverScrollableScrollPhysics(),
        ),
      ),
      
      bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
             Icon(Icons.language, size: 25,color: Colors.white,),
            Icon(Icons.home, size: 25,color: Colors.white,),
            Icon(Icons.notifications, size: 25,color: Colors.white),
            Icon(Icons.camera_alt, size: 25,color: Colors.white),
            Icon(Icons.search, size: 35,color: Colors.white),
            Icon(Icons.person, size: 25,color: Colors.white),
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