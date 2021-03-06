import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/post.dart';
import 'package:ploggly/pages/post_screen.dart';
import 'package:ploggly/widgets/custom_image.dart';
import 'package:video_player/video_player.dart';

class Postile extends StatefulWidget {
  final Post post;

  const Postile({Key key, this.post}) : super(key: key);
  @override
  _PostileState createState() => _PostileState();
  
}

class _PostileState extends State<Postile> {
  bool isVideo = false;
  VideoPlayerController _controller;
showPost(context){
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => PostScreen(postId: widget.post.postId,userId: widget.post.ownerId,))
    );
  }

  



  Future<void>_initalizedVideoPlayerFuture;
   bool checkIfVideo(){
     postRef
         .document(widget.post.ownerId)
         .collection('userPosts')
         .document(widget.post.postId)
         .get().then((doc){
       if(doc.data['videoURL'] != "" && doc.data['mediaURL'] == "") {
         setState(() {
           isVideo = true;
         _controller = VideoPlayerController.network(doc.data['videoURL']);
         _initalizedVideoPlayerFuture = _controller.initialize();

         });
         
       }
       });

   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfVideo();
  }

  @override
  Widget build(BuildContext context) {
    print("video $isVideo");
    return GestureDetector(
      onTap: ()=>showPost(context),
      child: isVideo ?
      Chewie(
        controller: ChewieController(
            videoPlayerController: _controller,
            aspectRatio: 1/1,
            showControls: false,
            overlay: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(child: Icon(Icons.play_arrow,size: 50.0,color: Colors.white,)),
            )

        ),
      ) : cachedNetworkImage(widget.post.mediaUrl)
    );
  }
}
