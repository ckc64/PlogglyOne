import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ploggly/pages/chatpages/chat_screen.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/pages/post_screen.dart';
import 'package:ploggly/pages/profile.dart';
import 'package:ploggly/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatFeed extends StatefulWidget {
  @override
  _ChatFeedState createState() => _ChatFeedState();
}

class _ChatFeedState extends State<ChatFeed> {

  getChatFeed() async{
      final chatFeedRef = Firestore.instance.collection('chatfeed');
   QuerySnapshot snapshot = await chatFeedRef
      .document(loggedInUser.uid)
      .collection('chatfeeditem')
      .orderBy('timestamp',descending: true)
      .getDocuments();
      List<ChatFeedItem>feedItems = [];
    snapshot.documents.forEach((doc){
      feedItems.add(ChatFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header("Messages"),
      body: Container(
        child: FutureBuilder(
          future: getChatFeed(),
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
class ChatFeedItem extends StatelessWidget {

  final String username;
  final String receiverId;
   final String senderId;
  final String userProfileImg;
  final String messageData;
  final Timestamp timestamp;

  const ChatFeedItem({Key key, this.username, 
  this.receiverId,this.senderId, this.userProfileImg, 
  this.messageData, this.timestamp}) : super(key: key);

  factory ChatFeedItem.fromDocument(DocumentSnapshot doc){
    return ChatFeedItem(
      username: doc['username'],
      receiverId: doc['receiverID'],
      userProfileImg: doc['profpic'],
      messageData: doc['message'],
      timestamp: doc['timestamp'],
      senderId: doc['sender']
    );
  }


  



  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom:2.0),
      child:  Container(
            color:Colors.pink,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>Navigator.push(context, 
        MaterialPageRoute(builder: (context)=>ChatScreen(profileID: senderId==loggedInUser.uid ? receiverId:senderId,))
      ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(userProfileImg),
                    ),
                    title: Text(username,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    subtitle: Text(messageData,style: TextStyle(color: Colors.white),),
                  ),
                ),
                Divider(height: 2.0,color: Colors.white54,)
              ],
            ),
          ),
    );
  }
}
