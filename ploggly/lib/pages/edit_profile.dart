import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/loginpages/ui/login_page.dart';
import 'package:ploggly/pages/profile.dart';
import 'package:ploggly/pages/search.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
class EditProfile extends StatefulWidget {

  final String currentUserID;

  const EditProfile({Key key, this.currentUserID}) : super(key: key);


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 bool isLoading = false;
 TextEditingController displayNameController = new TextEditingController();
 TextEditingController bioController = new TextEditingController();

 final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _bioValid = true,
  _displayNameValid = true;


  final userRef = Firestore.instance.collection('users');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async{
     setState(() {
      isLoading = true; 
     });
     
     final docRef = Firestore.instance
        .collection('users')
        .document(widget.currentUserID);

        docRef.get().then((doc){
            if (doc.exists) {
                displayNameController.text = doc.data['name'];
                bioController.text = doc.data['bio'];
                setState(() {
                  isLoading = false; 
                });
             
    } else {
        // doc.data() will be undefined in this case
        print("No such document!");
    }
        });
      
  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Display Name",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Montserrat'
          ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name Too Short"
          ),
        ),
      ],
    );
  }

   Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Bio",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Montserrat'
          ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
             errorText: _bioValid ? null : "Bio Too Long"
          ),
        ),
      ],
    );
  }

  updateProfileData(){
      setState(() {
        displayNameController.text.trim().length < 3 || displayNameController.text.isEmpty ?
        _displayNameValid = false : _displayNameValid = true;
        bioController.text.trim().length > 100 ? _bioValid=false : _bioValid =true;
      });

      if(_displayNameValid && _bioValid){
          userRef.document(widget.currentUserID).updateData({
            "name":displayNameController.text,
            "bio":bioController.text,
          });


          SnackBar snackBar = SnackBar(content: Text("Profile Update!"),);
          _scaffoldKey.currentState.showSnackBar(snackBar);
      }
  }

  logout() async {
    await fAuth.signOut();
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context)=>LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color:Colors.black,
          )
        ),
        actions: <Widget>[
          
          IconButton(
            onPressed: ()=>Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => Profile(profileID: widget.currentUserID,))
    ),
            icon: Icon(Icons.done,
            size: 30.0,
            color: Colors.green,
            ),
          )
        ],
      ),
      body: isLoading ? circularProgress():ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0,bottom: 8.0,),
                  child: FutureBuilder(
                    future: userRef.document(widget.currentUserID).get(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                          return circularProgress();
                      }
                      return CircleAvatar(
                        radius: 50.0,
                        backgroundImage: CachedNetworkImageProvider(snapshot.data['profpic']),

                      );
                    }
                    
                  )
                  
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  color: Colors.pink,
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 20.0
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: logout,
                    icon: Icon(Icons.cancel,
                    color:Colors.red
                    ),
                    label: Text("Logout",style: TextStyle(color: Colors.red,fontSize: 20.0,fontFamily: 'Montserrat'),),
                  ),

                )
              ],
            ),
          )
        ],
      ),
    );
  }
}