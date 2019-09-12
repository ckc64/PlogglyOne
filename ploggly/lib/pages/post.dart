import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/search.dart';
import 'package:ploggly/widgets/progress.dart';

class Post extends StatefulWidget {

  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;



  Post({
     this.postId,
  this.ownerId,
  this.username,
  this.location,
  this.description,
  this.mediaUrl,
  this.likes, 
  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc['postID'],
      ownerId: doc['ownerID'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaURL'],
      likes: doc['likes'],
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

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
  );
}

class _PostState extends State<Post> {


final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;

  _PostState({
     this.postId,
  this.ownerId,
  this.username,
  this.location,
  this.description,
  this.mediaUrl,
  this.likes,
  this.likeCount,
  });
 
  buildPostHeader(){
     //final userRef = Firestore.instance.collection('users');
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
              onTap: ()=>print('show profile'),
              child: Text(
                snapshot.data['username'],
                style: TextStyle(
                  color:Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            subtitle: Text(location),
            trailing: IconButton(
              onPressed: ()=>print('deleting posts'),
              icon: Icon(Icons.more_vert),
            ),
         );
      }
    );
  }

  buildPostImage(){
    return GestureDetector(
      onDoubleTap: ()=>print('likng post'),
      child: Stack(
        children: <Widget>[
          Image.network(mediaUrl),
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
                child: Icon(
                  Icons.favorite_border,
                  size:28.0,
                  color:Colors.pink,
                ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
            GestureDetector(
              onTap: ()=>print('show comments'),
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
                  "$username",
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter()

      ],
    );
  }
}