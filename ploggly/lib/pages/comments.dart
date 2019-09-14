import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'comments.dart';

class Comments extends StatefulWidget {

  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({
    this.postId,this.postOwnerId,this.postMediaUrl
  });

  @override
  _CommentsState createState() => _CommentsState(
    postId:this.postId,
    postOwnerId:this.postOwnerId,
    postMediaUrl:this.postMediaUrl
  );
}

class _CommentsState extends State<Comments> {
    TextEditingController commentController = TextEditingController();
    final commentsRef = Firestore.instance.collection("comments");
    FirebaseAuth fAuth = FirebaseAuth.instance;
    FirebaseUser loggedInUser;
     
   final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  _CommentsState({
    this.postId,this.postOwnerId,this.postMediaUrl
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
        final user = await fAuth.currentUser();
        if(user != null){
          loggedInUser = user;
        }

    }


  
  buildComments(){
      return StreamBuilder(
        stream: commentsRef.document(postId).collection("comments")
        .orderBy("timestamp",descending:false).snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return circularProgress();
          }
            List<Comment>comments = [];
            snapshot.data.documents.forEach((doc){
              comments.add(Comment.fromDocument(doc));
            });
            return ListView(children: comments,);
        }
      );
  }

  addComment(){
print(loggedInUser.uid);
     final userRef = Firestore.instance.collection('users').document(loggedInUser.uid);
      
      
        userRef.get().then((doc){
            if (doc.exists) {
                  commentsRef.document(postId)
                  .collection("comments")
                  .add({
                    "username":doc.data["username"],
                    "comment":commentController.text,
                    "timestamp":DateTime.now(),
                    "avatarUrl":doc.data["profpic"],
                    "userId":loggedInUser.uid
                  });  
                  commentController.clear();         
    } else {
        // doc.data() will be undefined in this case
        print("No such document!");
    }
        });

  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header("Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments(),),
          Divider(),
          ListTile(
            title:TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment..."
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {

  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
      this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp,
  });

   factory Comment.fromDocument(DocumentSnapshot doc){
      return Comment(
        username:doc['username'],
        userId:doc['userId'],
        comment:doc['comment'],
        timestamp: doc['timestamp'],
        avatarUrl: doc['avatarUrl'],
      );
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text(comment),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl),
            ),
            subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}