import 'dart:io';
//post is always loading need to fix
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/pages/search.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

class Upload extends StatefulWidget {

 final currentUser;

  const Upload({Key key, this.currentUser}) : super(key: key);
  
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  VideoPlayerController _controller;
  
  File file;
  final userRef = Firestore.instance.collection('users');
  final postRef = Firestore.instance.collection('posts');
  bool isUploading = false;
  File _image;
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  String username;
  //controller
  TextEditingController locationController = new TextEditingController();
  TextEditingController captionController = new TextEditingController();
  File videoFile;
  bool isVideo=false;
  //unique for post
  String profileID = Uuid().v4();
  Future<void>_initalizedVideoPlayerFuture;


  handleTakePhoto() async{
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.camera,
    maxHeight: 675,
    maxWidth: 960);

    setState(() {
      this.file = file; 
    });
  }

  handleChooseFromGallery() async{
    Navigator.pop(context);

    File file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.file = file; 
    });
  }

  handleRecordVideo() async{
    File file = await ImagePicker.pickVideo(
      source: ImageSource.camera,
    );

    if(file != null){
      setState(() {
       this.file=file; 
       isVideo = true;
       _controller = VideoPlayerController.file(file);
       _initalizedVideoPlayerFuture = _controller.initialize();
      });
    }
    print(isVideo);
  }

  selectImage(parentContext){
       return showDialog(
         context: parentContext,
         builder: (context){
           return SimpleDialog(
             title: Text("Create Post"),
             children: <Widget>[
               SimpleDialogOption(child: Text("Photo with Camera"),
                onPressed: handleTakePhoto,
               ),
               SimpleDialogOption(child: Text("Image From Gallery"),
                onPressed: handleChooseFromGallery,
               ),
                 SimpleDialogOption(child: Text("Take A Video"),
                onPressed: handleRecordVideo,
                 ),
               SimpleDialogOption(child: Text("Cancel"),onPressed: ()=>Navigator.pop(context),),

             ],
           );
         }
       );
  }
  
Container buildSplashScreen(){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 250.0,),
                Padding(
                  padding: EdgeInsets.only(top:20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text('Upload Image',
                    style: TextStyle(fontFamily: 'Montserrat',color:Colors.white,fontSize: 20.0),
                    ),
                    color: Colors.pink,
                    onPressed: () => selectImage(context),
                  ),
                ),
              ],
            ),
          );
}

  clearImage(){
    setState(() {
      file = null;
    });
  }

  handleSubmit() async{
    setState(() {
      isUploading = true;
    });
    isVideo ? "" : await compressImage() ;
    String mediaUrl = isVideo ?  await uploadVideo(file): await uploadImage(file);
    createPostInFireStore(
      description: captionController.text,
      location: locationController.text,
      mediaUrl: mediaUrl
    );

   
     locationController.clear();
     captionController.clear() ;
     _controller.dispose();
     setState(() {
      file=null;
      isUploading = false;
      profileID = Uuid().v4();
     });
   
  }

  createPostInFireStore({String mediaUrl,String location, String description}){
  
     final docRef = Firestore.instance
        .collection('users')
        .document(widget.currentUser);

        docRef.get().then((doc){
            if (doc.exists) {
                
               try{
       postRef
          .document(widget.currentUser)
          .collection("userPosts")
          .document(profileID)
          .setData({
            "postID":profileID,
            "ownerID":widget.currentUser,
            "username":doc.data["username"],
            "mediaURL":mediaUrl,
            "description":description,
            "location": location,
            "timestamp":DateTime.now(),
            "likes":{},

          });
      }catch(e){
        print(e);
      }       
    } else {
        // doc.data() will be undefined in this case
        print("No such document!");
    }
        });
   
}



  

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressImageFile = File('$path/img_$profileID.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));

    setState(() {
      file = compressImageFile;

    });

  }

  Future<String>uploadImage(imageFile) async{
    StorageUploadTask uploadTask = storageRef.child("post_$profileID.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String>uploadVideo(videoFile) async{
      StorageUploadTask uploadTask = storageRef.child("video_$profileID").putFile(file);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
  }



  Scaffold buildUploadForm(){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color:Colors.black),
            onPressed: clearImage,
          ),
          title: Text("Caption Post",
          style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: isUploading ? null : () => handleSubmit(),
              child: Text("Post",
              style: TextStyle(color:Colors.blueAccent,fontFamily: 'Montserrat',fontSize: 20.0),),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(""),
              Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width*0.8,
                child: isVideo ? Chewie(
                  controller: ChewieController(
                    videoPlayerController: _controller,
                    aspectRatio: 16/9,
                    autoPlay: false,
                    looping: true
                  ),
                ) : Center(
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child:Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit:BoxFit.cover,
                          image:FileImage(file),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            FutureBuilder(
              
              future: userRef.document(widget.currentUser).get(),
              
              builder: (context,snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                return ListTile(
                  
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        snapshot.data['profpic']),
                  ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      controller: captionController,
                      decoration: InputDecoration(
                        hintText: "Write a caption..",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                );
              }
            ),


            Divider(),
            ListTile(
              leading: Icon(Icons.pin_drop,color:Colors.pink,size:35.0),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: "Location",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              width: 200.0,
              height: 100.0,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                  onPressed: getUserLocation,
                  icon: Icon(Icons.my_location,color: Colors.white,),
                  label:Text("Use Current Location",
                  style: TextStyle(color:Colors.white),
                  ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                color: Colors.pink,
              ),

            )
          ],
        ),
      );
  }

  getUserLocation() async{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     List<Placemark> placemarks = 
     await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
     Placemark placemark = placemarks[0];
     String completeAddress = '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality}${placemark.locality}, ${placemark.subAdministrativeArea},${placemark.administrativeArea},${placemark.postalCode}, ${placemark.country}';
     
     print(completeAddress);
    String formattedAddress = "${placemark.locality},${placemark.country}";
    locationController.text = formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
          return file == null ? buildSplashScreen() : buildUploadForm();
    }
  }
