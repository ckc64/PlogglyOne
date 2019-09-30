import 'package:flutter/material.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/widgets/progress.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        print(message.data);
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
                          "receiver":widget.profileID
                       });

                       await messageRef.document(widget.profileID)
                       .collection('conversation')
                       .document('receivers')
                       .collection(loggedInUser.uid)
                       .document()
                       .setData({
                          "sender":loggedInUser.email,
                          "message":messageTxt,
                          "receiver":widget.profileID
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
              .collection(this.profileID).snapshots(),
              builder: (context,snapshots){
                if(!snapshots.hasData){
                    return circularProgress();
                }
                final messages = snapshots.data.documents;
                List<MessageBubble>messageBubbles = [];
                for(var message in messages){
                    final messageText = message.data['message'];
                    final sender = message.data['sender'];
                    final currentUser = loggedInUser.email;
                    final messageBubble = MessageBubble(
                      sender: sender,
                      text: messageText,
                      isMe: currentUser==sender,
                      );
                    messageBubbles.add(messageBubble);
                }
                return Expanded(
                     child: ListView(
                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
  const MessageBubble({Key key, this.sender, this.text,this.isMe}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30.0)
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
        ],
      ),
    );
  }
}