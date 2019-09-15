import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:ploggly/widgets/progress.dart';

class PostScreen extends StatelessWidget {

  final String userId,postId;

  PostScreen({Key key, this.userId, this.postId}) : super(key: key);

  final postRef = Firestore.instance.collection('posts');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postRef.document(userId).collection('userPosts').document(postId).get(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },

    );
  }
}