import 'package:flutter/material.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/widgets/progress.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
FirebaseAuth fAuth = FirebaseAuth.instance;
  final messageRef = Firestore.instance.collection('messages');
class ChatScreen extends StatefulWidget {
  final profileID;

  const ChatScreen({Key key, this.profileID}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    //FirebaseUser loggedInUser;
    TextEditingController messageController = TextEditingController();
    String messageTxt;
     Timestamp timestamp;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.profileID);
    messageStream();
  }

 
  messageStream() async{
    await for(var snapshot in messageRef.snapshots()){
      for(var message in snapshot.documents){
        print(message.data['timestamp']);
      }    
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text('Messages'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
         
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(profileID: widget.profileID,),
            
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: kMessageTextFieldDecoration,
                      onChanged: (value){
                        messageTxt = value;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                        messageController.clear();

                       await messageRef.document(loggedInUser.uid)
                       .collection('conversation')
                       .document('receivers')
                       .collection(widget.profileID)
                       .document()
                       .setData({
                          "sender":loggedInUser.email,
                          "message":messageTxt,
                          "receiver":widget.profileID,
                          "timestamp":DateTime.now()
                       });

                        await messageRef.document(widget.profileID)
                       .collection('conversation')
                       .document('receivers')
                       .collection(loggedInUser.uid)
                       .document()
                       .setData({
                          "sender":loggedInUser.email,
                          "message":messageTxt,
                          "receiver":widget.profileID,
                          "timestamp":DateTime.now()
                       });
                         
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final profileID;

  const MessagesStream({Key key, this.profileID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
              stream: messageRef.document(loggedInUser.uid)
              .collection('conversation')
              .document('receivers')
              .collection(this.profileID).orderBy('timestamp',descending: true).snapshots(),
              builder: (context,snapshots){
                if(!snapshots.hasData){
                    return circularProgress();
                }
                final messages = snapshots.data.documents;
                List<MessageBubble>messageBubbles = [];
                for(var message in messages){
                    final messageText = message.data['message'];
                    final sender = message.data['sender'];
                    final time = message.data['timestamp'];
                    final currentUser = loggedInUser.email;
                    final messageBubble = MessageBubble(
                      sender: sender,
                      text: messageText,
                      isMe: currentUser==sender,
                      timestamp: time,
                      );
                    messageBubbles.add(messageBubble);
                }
                return Expanded(
                     child: ListView(
                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                       reverse: true,
                    children:messageBubbles,
                  ),
                );
              },
            );
  }
}

class MessageBubble extends StatelessWidget {

  final String sender,text;
  final bool isMe;
  final Timestamp timestamp;
  const MessageBubble({Key key, this.sender, this.text,this.isMe, this.timestamp}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30.0) 
            ,bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30.0) 
            ,bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.pink : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  child: Text(
              "$text",
              style: TextStyle(
                  color: isMe? Colors.white : Colors.black,
                  fontSize: 15.0,
              ),
            ),
                ),
          ),
            Text(timeago.format(timestamp.toDate()),
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black45
            )
            ,)
        ],
      ),
    );
  }
}