import 'package:flutter/material.dart';
import 'package:ploggly/pages/edit_profile.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'upload.dart';

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
   final postRef = Firestore.instance.collection('posts');
String currentUserID;
bool isLoading =false;
int postCount =0;
List<Post> posts = [];

@override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    currentUserID = loggedInUser.uid;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getProfilePost();
  }

  getProfilePost() async{
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef.document("XLf6SDjq27qh70dZF8Ct")
    .collection('userPosts')
    .orderBy('timestamp',descending:true)
    .getDocuments();

    setState(() {
     isLoading =false;
     postCount = snapshot.documents.length;
    
     posts = snapshot.documents.map((doc) => Post.fromDocument(doc))
     .toList();
    });
  }


void getCurrentUser() async{
        final user = await fAuth.currentUser();
      
          loggedInUser = user;
        

    }



buildProfileHeader(){
  return FutureBuilder(
    future: userRef.document(widget.profileID).get(),
    builder: (context,snapshot){
      if(!snapshot.hasData){
          return circularProgress();
      }
      //final user = userRef.document(widget.profileID).snapshots();
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
            Row(children: <Widget>[
              CircleAvatar(radius: 40.0,
                backgroundColor: Colors.pink,
                backgroundImage: CachedNetworkImageProvider(snapshot.data['profpic']),
              ),
              Expanded(
                flex:1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCountColumn("posts",postCount),
                        buildCountColumn("followers",0),
                        buildCountColumn("following",0),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                          buildProfileButton()
                      ],
                    )
                  ],
                ),
              )
            ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top:12.0),
              child: Text(snapshot.data['username'],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
              ),
              ),
            ),
             Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top:4.0),
              child: Text(snapshot.data['name'],
              style: TextStyle(
               
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
              ),
              ),
            ),
             Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top:2.0),
              child: Text(snapshot.data['bio'],
              style: TextStyle(
               
                fontFamily: 'Montserrat'
              ),
              ),
            )
         ],
        ),
      );
    },
  );
}

Column buildCountColumn(String label, int count){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(
        count.toString(),
        style: TextStyle(
          fontSize:22.0,
          fontFamily: 'Montserrat',
        ),
      ),
      Container(
        margin: EdgeInsets.only(top:4.0),
        child: Text(
          label,
          style: TextStyle(
            color:Colors.grey,
            fontFamily: 'Montserrat',
            fontSize: 15,
          ),
        ),
      )
    ],
  );
}

editProfile(){
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => EditProfile(currentUserID: widget.profileID,))
    );
}
Container buildButton({String text,Function function}){
  return Container(
    padding: EdgeInsets.only(top:2.0),
    child: FlatButton(
      onPressed: function,
      child: Container(
        width: 250.0,
        height: 27.0,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.pink,
          border: Border.all(
            color: Colors.pink,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}

buildProfileButton(){
  //edit wen not ur profile
  bool isProfileOwner = widget.profileID == widget.profileID;
  if(isProfileOwner){
    return buildButton(
      text: "Edit Profile",
      function: editProfile
    );
  }
}

buildProfilePost(){
  if(isLoading){
    return circularProgress();
  }
  return Column(
    children: posts,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header("profile"),
        body: ListView(
          children: <Widget>[
              buildProfileHeader(),
              Divider(
                height: 0.0,
              ),
              buildProfilePost()
          ],
        ),
    );
  }
}


