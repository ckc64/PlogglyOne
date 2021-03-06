import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/activity_feed.dart';
import 'package:ploggly/pages/comments.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/pages/user.dart';
import 'package:ploggly/widgets/custom_image.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animator/animator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String videoUrl;
  final dynamic likes;
  final dynamic reports;
  User currentUser;
  

//fix current user id

  Post({
     this.postId,
  this.ownerId,
  this.username,
  this.location,
  this.description,
  this.mediaUrl,
  this.likes, 
  this.videoUrl,
  this.reports
  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc['postID'],
      ownerId: doc['ownerID'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaURL'],
      videoUrl: doc['videoURL'],
      likes: doc['likes'],
      reports: doc['reports'],
    );
  }

  int getLikeCount(likes){
    if(likes == null){
      return 0;
    }
    int count = 0;
    likes.values.forEach((val){
        if(val==true){
          count+=1;
        }
    });

    return count;
  }

   int getReportsCount(reports){
    if(reports == null){
      return 0;
    }
    int count = 0;
    reports.values.forEach((val){
        if(val==true){
          count+=1;
        }
    });

    return count;
  }



  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    videoUrl:this.videoUrl,
    likes: this.likes,
    reports: this.reports,
    likeCount: getLikeCount(this.likes),
    reportCount: getReportsCount(this.reports)
  );
}

final postRef = Firestore.instance.collection('posts');
   String email="",uid="",password="";
class _PostState extends State<Post> {
  VideoPlayerController _controller;
 Future<void>_initalizedVideoPlayerFuture;

 
  //bool isLoggedIn=false;
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("email") != null && prefs.getString("uid") !=null && prefs.getString("password") !=null) {
        email = prefs.getString("email");
        uid = prefs.getString("uid");
        password = prefs.getString("password");
        print("$email,$uid,$password");
        

      }
    });
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfVideo();
   // getUserCount();
  
    _function();
  }


  
final String currentUserID=loggedInUser.uid;
final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String videoUrl;
  int likeCount;
  int reportCount;
  Map likes;
  Map reports;
  bool isLiked;
  bool isReported;
  bool showHeart=false;
  
  _PostState({
     this.postId,
  this.ownerId,
  this.username,
  this.location,
  this.description,
  this.mediaUrl,
  this.likes,
  this.reports,
  this.videoUrl,
  this.likeCount,
  this.reportCount
  });

  int userCount;
  String reportText = " Report";
  buildPostHeader(){
     final userRef = Firestore.instance.collection('users');
    return FutureBuilder(
      future: userRef.document(ownerId).get(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
         
         return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(snapshot.data['profpic']),
              backgroundColor: Colors.grey
            ),
            title: GestureDetector(
              onTap: ()=>showProfile(context,profileId: ownerId),
              child: Text(
                snapshot.data['username'],
                style: TextStyle(
                  color:Colors.black,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            subtitle: Text(location),
            trailing: IconButton(
              onPressed: ()=>handleDeletePost(context),
              icon: Icon(Icons.more_vert),
            ),
         );
      }
    );
  }
  handleDeletePost(BuildContext parentContext){
    bool isPostOwner = loggedInUser.uid==ownerId;
      return showDialog(
        context: parentContext,
        builder: (context){
          return SimpleDialog(title: Text("Remove/Report this post?"),
          children: <Widget>[
            isPostOwner ? SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
                deletePost();
              },
              child: Text("Delete",
              style:TextStyle(color: Colors.red),
              ),
            ) : Text(""),
              isPostOwner ? Text("") : SimpleDialogOption(
              onPressed: (){
                
                //deletePost();
               
                handleReportPost();
                Navigator.pop(context);
              },
              child: Text(reportText),
            )  ,
              SimpleDialogOption(
                onPressed: ()=>Navigator.pop(context),
              child: Text("Cancel",
              ),
            ),
         
          ],
          );
        }
      );
  }




   getUserCount() async{
      QuerySnapshot snapshot = await userRef
      .getDocuments();
      setState(() {
        userCount = snapshot.documents.length;
      });
  }
 
   deletePost() async{
       final postRef = Firestore.instance.collection('posts');
       postRef
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
        });
        final StorageReference storageRef = FirebaseStorage.instance.ref();
        storageRef.child("post_$postId.jpg").delete();
        QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where("postId",isEqualTo: postId)
        .getDocuments();
        activityFeedSnapshot.documents.forEach((doc){
          if(doc.exists){
            doc.reference.delete();
          }
        });

       final commentsRef = Firestore.instance.collection("comments");
       QuerySnapshot commentSnapshot =  await commentsRef
       .document(postId)
       .collection("comments")
       .getDocuments();

       commentSnapshot.documents.forEach((doc){
          if(doc.exists){
            doc.reference.delete();
          }
       });
       Navigator.pop(context);
   }
  handleReportPost(){
     
    final postRef = Firestore.instance.collection('posts');
    bool _isReported= reports[currentUserID]==true;

           if(_isReported){
      postRef
      .document(ownerId)
      .collection('userPosts')
      .document(postId)
      .updateData({'reports.$currentUserID':false});
     
      setState(() {
       reportCount -= 1;
       isReported = false;
       reports[currentUserID]=false;
       reportText = "Report";
      });
    }else if(!_isReported){
       postRef
      .document(ownerId)
      .collection('userPosts')
      .document(postId)
      .updateData({'reports.$currentUserID':true});
     
      setState(() {
       reportCount += 1;
       isReported = true;
       reports[currentUserID]=true;
      reportText = "Reported";
      });
    }
      
      
  }
  handleLikePost(){
  
    final postRef = Firestore.instance.collection('posts');
    bool _isLiked = likes[currentUserID]==true;
 
    if(_isLiked){
      postRef
      .document(ownerId)
      .collection('userPosts')
      .document(postId)
      .updateData({'likes.$currentUserID':false});
      removeLikeToActivityFeed();
      setState(() {
       likeCount -= 1;
       isLiked = false;
       likes[currentUserID]=false;
      });
    }else if(!_isLiked){
       postRef
      .document(ownerId)
      .collection('userPosts')
      .document(postId)
      .updateData({'likes.$currentUserID':true});
         addLikeToActivityFeed();
      setState(() {
       likeCount += 1;
       isLiked = true;
       likes[currentUserID]=true;
       showHeart = true;
      });
      Timer(Duration(milliseconds: 700),(){
          setState(() {
            showHeart = false; 
          });
      });
    }
  }
 

  removeLikeToActivityFeed(){
    final activityFeedRef = Firestore.instance.collection('feed');
  final userRef = Firestore.instance.collection('users').document(currentUserID);
      userRef.get().then((doc){
            if (doc.exists) {
                  activityFeedRef
      .document(ownerId)
      .collection('feedItems')
      .document(postId)
      .get().then((doc){
          if(doc.exists){
              doc.reference.delete();
          }
      });
    } else {
        // doc.data() will be undefined in this case
        print("remove like No such document!");


    }
        });
    

  }

  addLikeToActivityFeed(){
final activityFeedRef = Firestore.instance.collection('feed');
  final userRef = Firestore.instance.collection('users').document(currentUserID);

    bool isNotPostOwner = currentUserID != ownerId;

    if(isNotPostOwner){
        userRef.get().then((doc){
            if (doc.exists) {
                  activityFeedRef
      .document(ownerId)
      .collection('feedItems')
      .document(postId)
      .setData({
        "type":"like",
        "username":doc.data['username'],
        "userId":currentUserID,
        "userProfileImg":doc.data['profpic'],
        "postId":postId,
        "mediaUrl":mediaUrl,
        "videoURL":videoUrl,
        "timestamp":DateTime.now()
      });     
    } else {
        // doc.data() will be undefined in this case
        print("add like No such document!");
    }
        });
    }

  }
bool isVideo = false;
 bool checkIfVideo(){
    final postRef = Firestore.instance.collection('posts');
    postRef
      .document(ownerId)
      .collection('userPosts')
      .document(postId)
      .get().then((doc){
          if(doc.data['videoURL'] != "" && doc.data['mediaURL'] == ""){
            setState(() {
              isVideo = true;
              _controller = VideoPlayerController.network(doc.data['videoURL']);
              _initalizedVideoPlayerFuture = _controller.initialize();
            });

          }

    print("videoURL "+doc.data['videoURL']);

          print("Is Video : $isVideo");
        return isVideo;
        
      });

     
 }
  
   buildPostVideo(){
     return GestureDetector(
       onDoubleTap: handleLikePost,
       child: Stack(
         alignment: Alignment.center,
         children: <Widget>[

          Chewie(
            controller: ChewieController(
                videoPlayerController: _controller,
                aspectRatio: 12/9,
                autoPlay: false,
                looping: true
            ),
          ),

           showHeart ? Animator(
             duration: Duration(milliseconds: 300),
             tween: Tween(begin: 0.8, end:1.4),
             curve: Curves.easeIn,
             cycles: 0,
             builder: (anim)=>Transform.scale(
               scale: anim.value,
               child: Icon(Icons.favorite,size: 150.0,color:Colors.redAccent),
             ),
           ) : Text(""),

         ],
       ),
     );
   }

  buildPostImage(){

    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
   
          cachedNetworkImage(mediaUrl),
          
         showHeart ? Animator(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end:1.4),
            curve: Curves.easeIn,
            cycles: 0,
            builder: (anim)=>Transform.scale(
              scale: anim.value,
              child: Icon(Icons.favorite,size: 150.0,color:Colors.redAccent),
            ),
          ) : Text(""),
        
        ],
      ),
    );
  }

  buildPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:40.0,left: 20.0),
            ),
            GestureDetector(
                onTap: handleLikePost,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size:28.0,
                  color:Colors.pink,
                ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
            GestureDetector(
              onTap: ()=>showComments(
                context,
                postId:postId,
                ownerId:ownerId,
                mediaUrl:mediaUrl
              ),
                child: Icon(
                  Icons.chat,
                  size:28.0,
                  color:Colors.blue[900],
                ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                  "$likeCount likes",
                  style: TextStyle(color:Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
            Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                  "$username ",
                  style: TextStyle(color:Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(description),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserID]==true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        isVideo ? buildPostVideo() : buildPostImage(),
        buildPostFooter()

      ],
    );
  }
}

showComments(BuildContext context,{String postId,String ownerId,String mediaUrl,String videoUrl}){

  Navigator.push(context,MaterialPageRoute(builder: (context){
    return Comments(
      postId:postId,
      postOwnerId:ownerId,
      postMediaUrl:mediaUrl,
      postVideoUrl: videoUrl,
    );
  }));
}