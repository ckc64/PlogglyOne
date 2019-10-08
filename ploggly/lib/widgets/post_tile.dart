import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/pages/post_screen.dart';
import 'package:ploggly/widgets/custom_image.dart';
import 'package:video_player/video_player.dart';


class PostTile extends StatelessWidget {
  final Post post;



  PostTile(this.post,);
  showPost(context){
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => PostScreen(postId: post.postId,userId: post.ownerId,))
    );
  }

  bool isVideo = false;
  VideoPlayerController _controller;
  Future<void>_initalizedVideoPlayerFuture;
  // bool checkIfVideo(){
  //   postRef
  //       .document(post.ownerId)
  //       .collection('userPosts')
  //       .document(post.postId)
  //       .get().then((doc){
  //     if(doc.data['videoURL'] != "" && doc.data['mediaURL'] == "") {
  //       isVideo = true;
  //       _controller = VideoPlayerController.network(doc.data['videoURL']);
  //       _initalizedVideoPlayerFuture = _controller.initialize();
  //     }
  //     });

  // }


  @override
  Widget build(BuildContext context) {
print("Post tile : $isVideo");
    return GestureDetector(
      onTap: ()=>showPost(context),
      child:
          cachedNetworkImage(post.mediaUrl)
    );
  }
}