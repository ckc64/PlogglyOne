import 'package:flutter/material.dart';
import 'package:ploggly/pages/home.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final profileID;

  const ChatScreen({Key key, this.profileID}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

    FirebaseAuth fAuth = FirebaseAuth.instance;
    //FirebaseUser loggedInUser;
    TextEditingController messageController = TextEditingController();
    final messageRef = Firestore.instance.collection('messages');
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
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                       await messageRef.document(loggedInUser.uid)
                       .collection('conversation')
                       .document('receivers')
                       .collection(widget.profileID)
                       .document()
                       .setData({
                          "sender":loggedInUser.email,
                          "message":messageController.text,
                          "receiver":widget.profileID
                       });
                       messageController.clear();

                            // .add({
                            //   "sender":loggedInUser.email,
                            //   "message":messageController.text,
                            //   "receiver":widget.profileID
                            // });
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
