import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/pages/post_screen.dart';
import 'package:ploggly/widgets/custom_image.dart';
import 'package:video_player/video_player.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);
  showPost(context){
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => PostScreen(postId: post.postId,userId: post.ownerId,))
    );
  }

  bool checkIfVideo(){
    if(post.mediaUrl == "" && post.videoUrl != "" ){
        return true;
    }else{
         return false;
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}