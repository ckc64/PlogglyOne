import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/pages/post_screen.dart';
import 'package:ploggly/pages/profile.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {

  getActivityFeed() async{
      final activityFeedRef = Firestore.instance.collection('feed');
   QuerySnapshot snapshot = await activityFeedRef
      .document(loggedInUser.uid)
      .collection('feedItems')
      .orderBy('timestamp',descending: true)
      .limit(30)
      .getDocuments();
      List<ActivityFeedItem>feedItems = [];
    snapshot.documents.forEach((doc){
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header("Activity Feed"),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return circularProgress();
            }
           return ListView(
             children: snapshot.data,
           );
          },
        ),
      ),
    
    );
  }
}

  Widget mediaPreview;
  String activityItemText;
class ActivityFeedItem extends StatelessWidget {

  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  const ActivityFeedItem({Key key, this.username, 
  this.userId, this.type, this.mediaUrl, 
  this.postId, this.userProfileImg, 
  this.commentData, this.timestamp}) : super(key: key);

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc){
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }



  showPost(BuildContext context){
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => PostScreen(userId: loggedInUser.uid,postId: postId))
    );
  }
  
  configureMediaPreview(BuildContext context){
    if(type == "like" || type == "comment"){
        mediaPreview = GestureDetector(
          onTap: ()=>showPost(context),
          child: Container(
            height:50.0,
            width: 50.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ) 
              ),
            ),
          ),
        );
    }else{
      mediaPreview = Text("");
    }

      if(type == "like"){
        activityItemText = " liked your post";
      }else if(type == "follow"){
        activityItemText = " is following you";
      }else if(type == "comment"){
        activityItemText = ' replied: $commentData';
      }else{
        activityItemText = 'Error unknown type';
      }
  }



  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom:2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: ()=>showProfile(context,profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '$activityItemText')
                ]
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            
              timeago.format(timestamp.toDate()),
              overflow:TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context,{String profileId}){
   
  Navigator.push(context,MaterialPageRoute(builder: (context)=>Profile(profileID: profileId,)));
 
 
}