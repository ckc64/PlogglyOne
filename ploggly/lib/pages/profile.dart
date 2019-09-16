import 'package:flutter/material.dart';
import 'package:ploggly/pages/edit_profile.dart';
import 'package:ploggly/pages/home.dart' as prefix0;
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ploggly/widgets/post_tile.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  final String profileID;

  const Profile({Key key, this.profileID}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
bool isFollowing = false;

FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
 
 final userRef = Firestore.instance.collection('users');
   final postRef = Firestore.instance.collection('posts');
String currentUserID;
int followerCount =0;
int followingCount = 0;

String postOrientation="grid";
bool isLoading =false;
int postCount =0;
List<Post> posts = [];

void getCurrentUserID(){
  setState(() {
   currentUserID = loggedInUser.uid; 
  });
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    //getCurrentUserID();
    getProfilePost();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing()async{
      DocumentSnapshot doc = await prefix0.followersRef.document(widget.profileID)
      .collection('userFollowers')
      .document(prefix0.loggedInUser.uid)
      .get();
      setState(() {
        isFollowing = doc.exists;
      });
  }

  getFollowers() async{
      QuerySnapshot snapshot = await prefix0.followersRef.document(widget.profileID)
      .collection('usersFollowing')
      .getDocuments();
      setState(() {
        followerCount = snapshot.documents.length;
      });
  }

  getFollowing() async{
      QuerySnapshot snapshot = await prefix0.followingRef.document(widget.profileID)
      .collection('usersFollowing')
      .getDocuments();
      setState(() {
        followingCount = snapshot.documents.length;
      });
  }


  getProfilePost() async{
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef.document(widget.profileID)


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
                        buildCountColumn("followers",followerCount),
                        buildCountColumn("following",followingCount),
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
            color: isFollowing ? Colors.black :Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white : Colors.pink, 
          border: Border.all(
            color: isFollowing ? Colors.grey : Colors.pink,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}

buildProfileButton(){
  //edit wen not ur profile
  bool isProfileOwner = loggedInUser.uid == widget.profileID;
  if(isProfileOwner){
    return buildButton(
      text: "Edit Profile",
      function: editProfile
    );
  }else if(isFollowing){
    return buildButton(
      text: "Unfollow",
      function: handleUnfollowUser
    );
  }else if(!isFollowing){
     return buildButton(
      text: "Follow",
      function: handleFollowUser
    );
  }
}

handleUnfollowUser(){
  setState(() {
    isFollowing = false; 
  });
  followersRef
    .document(widget.profileID)
    .collection('usersFollower')
    .document(prefix0.loggedInUser.uid)
    .get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }else{
        print("$currentUserID followers dont exist "+widget.profileID);
      }
    });

    //update following collection
    followingRef
    .document(prefix0.loggedInUser.uid)
    .collection('usersFollowing')
    .document(widget.profileID)
    .get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }else{
        print("$currentUserID following dont exist "+widget.profileID);
      }
    });

}

handleFollowUser(){
  setState(() {
    isFollowing = true; 
  });

  followersRef
    .document(widget.profileID)
    .collection('usersFollower')
    .document(prefix0.loggedInUser.uid)
    .setData({

    });

    //update following collection
    followingRef
    .document(prefix0.loggedInUser.uid)
    .collection('usersFollowing')
    .document(widget.profileID)
    .setData({});

    //add notification
     final userRef = Firestore.instance.collection('users').document(prefix0.loggedInUser.uid);
    userRef.get().then((doc){
            if (doc.exists) {
                  activityFeedRef
    .document(widget.profileID)
    .collection('feedItems')
    .document(prefix0.loggedInUser.uid)
    .setData({
       "type":"follow",
      "ownerId":widget.profileID,
      "username":doc.data['username'],
      "userProfileImg":doc.data['profpic'],
      "timestamp":DateTime.now(),
      });     
    } else {
        // doc.data() will be undefined in this case
        print("add like No such document!");
    }
        });

  
}

setPostOrientation(String postOrientation){
  setState(() {
     this.postOrientation = postOrientation;
  });
 
}
buildProfilePost(){
  if(isLoading){
    return circularProgress();
  // }else if(posts.isEmpty){
  //   Center(
  //     child: Text("No Posts",
  //       style: TextStyle(
  //         color: Colors.redAccent,
  //         fontSize: 40.0,
  //         fontFamily: 'Montserrat',
  //         fontWeight: FontWeight.bold
  //       ),
  //     ),
  //   );
  }
  else if(postOrientation == "grid"){
      
    List<GridTile>gridTiles = [];
      posts.forEach((post){
            gridTiles.add(GridTile(
              child:  PostTile(post)
            ));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
      
  } else if(postOrientation == "list"){
    
      return Column(
          children: posts,
        );
  }
 
}

  Row buildTogglePostOrientation(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            onPressed: ()=>setPostOrientation("grid"),
            icon: Icon(Icons.grid_on),
            color:postOrientation == "grid" ? Colors.pink : Colors.grey,
          ),
           IconButton(
            onPressed: ()=>setPostOrientation("list"),
            icon: Icon(Icons.list),
            color:postOrientation == "list" ? Colors.pink : Colors.grey,
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header("profile"),
        body: ListView(
          children: <Widget>[
              buildProfileHeader(),
              Divider(),
              buildTogglePostOrientation(),
              Divider(
                height: 0.0,
              ),
              buildProfilePost()
          ],
        ),
    );
  }
}


