import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/pages/search.dart' as prefix0;
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/widgets/progress.dart';
import 'activity_feed.dart';
import 'home.dart';

class WorldTimeline extends StatefulWidget {
 final currentUser;

  const WorldTimeline({Key key, this.currentUser}) : super(key: key);
  @override
  _WorldTimelineState createState() => _WorldTimelineState();
  
}

class _WorldTimelineState extends State<WorldTimeline> {
  final worldPostRef = Firestore.instance.collection('WorldPosts');
  List<Post> posts;
List<String> followingList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeline();

  }

  getTimeline()async{

    QuerySnapshot snapshot = await worldPostRef
      .orderBy('timestamp',descending: true)
      .getDocuments();
      List <Post> posts = snapshot.documents.map((doc)=>Post.fromDocument(doc)).toList();

      setState(() {
       this.posts=posts; 
      });
  }

  buildTimeline(){
    if(posts==null){
      return circularProgress();
    }else if(posts.isEmpty){
      //return Text("posts");
      buildUsersToFollow();
    }
    return ListView(children: posts,);
  }

  buildUsersToFollow(){
    final userRef = Firestore.instance.collection('users');
    return StreamBuilder(
      stream: userRef.orderBy('timestamp',descending:true).limit(30)
      .snapshots(),
        builder: (context,snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
    
        List<Container> searchResults = [];
        snapshot.data.documents.forEach((doc){
              // final bool isAuthUser = loggedInUser.uid==doc['userid'];
              // final bool isFollowing = followingList.contains(doc['userid']);
              // if(isAuthUser){
              //   return;
              // }else if(isFollowing){
              //   return;
              // }

                  searchResults.add(
          Container(
            color:Colors.pink,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>showProfile(context,profileId: doc['userid']),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(doc['profpic']),
                    ),
                    title: Text(doc['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    ),
                    subtitle: Text(doc['username'],style: TextStyle(color: Colors.white),),
                  ),
                ),
                Divider(height: 2.0,color: Colors.white54,)
              ],
            ),
          )
          );
               
           
       
        });
        //  print("Current User "+ loggedInUser.uid+ " doc id "+ doc['userid']+"Follwing list ");
          print("search $searchResults");
          print("userRef"+snapshot.data);
          return ListView(
            children: searchResults
        );
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: header("ploggly"),
      body: RefreshIndicator(
        onRefresh: ()=>getTimeline(),
        child: buildTimeline(),
      ),
    );
  }
}