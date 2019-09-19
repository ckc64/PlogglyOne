import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

import 'package:uuid/uuid.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'login_page.dart';

class FirsTimePage extends StatefulWidget {
  
  @override
 _FirsTimePageState createState() => _FirsTimePageState();
}

class _FirsTimePageState extends State<FirsTimePage> {

  //spinner
  bool showSpinner = false;
  //controllers
    TextEditingController nameController = new TextEditingController();
    TextEditingController usernameController = new TextEditingController();
    TextEditingController bioController = new TextEditingController();

  FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  String username;

  //unique for post 
String profileID = Uuid().v4();
    //Fire Store
    final userRef = Firestore.instance.collection('users');
  

    void getCurrentUser() async{
        final user = await fAuth.currentUser();
        if(user != null){
          loggedInUser = user;
        }

    }
String id;
int bDateYear=0;

@override
  void setState(fn) async{
    // TODO: implement setState
    super.setState(fn);
    getCurrentUser();
    id = loggedInUser.uid;
  
  }

  int _currentStep =0;
  File _image;


// state variable
 int _radioValue = 0;
  String _value = 'Male';
  
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
  
      switch (_radioValue) {
        case 0:
          _value = 'Male';
         
          break;
        case 1:
          _value = 'Female';
          break;
        case 2:
          _value = 'LGBTQ';
          break;
      }
    });

     print(_value);
  }

 String _date = "Birthdate";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
         Navigator.pushReplacement(context,
                                    MaterialPageRoute (builder: (context)=>LoginPage())
                                  );
      },
          child: Scaffold(
          body:  ModalProgressHUD(
                  inAsyncCall:showSpinner,
                    child: SingleChildScrollView(
                      child: Column(
                        
                children: <Widget>[
                   Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Text(
                              'set up account ',
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontFamily: 'Pacifico',
                                  fontSize: 35.0),
                            )),
                  Stepper(
                        steps:  _signUpStep(),
                        currentStep: this._currentStep,
                        onStepTapped: (step){
                          setState(() {
                            this._currentStep = step; 
                          });
                        },
                        onStepContinue: () {
                            setState(() {
                              if(this._currentStep < this._signUpStep().length-1){
                                this._currentStep = this._currentStep+1;
                              }else{
                                  setState(() {
                                   showSpinner=true;
                                  }); 

                                  createUser();    
                                  
                              } 
                            });
                        },
                        onStepCancel: (){
                          setState(() {
                           if(this._currentStep>0){
                              this._currentStep = this._currentStep-1;
                           }else{
                             this._currentStep = 0;
                           } 
                          });
                        },
                        
        
                    ),


                ],
              ),
            ),
          ),
          
        
      ),
    );
  }

  List<Step>_signUpStep(){
    List<Step>_steps = [
        Step(
        
          title: Text('Profile Picture',
            style: TextStyle(color: Colors.pink,fontFamily: 'Pacifico',fontSize: 25.0)),
          content: _CircleUploadAvatar(context),
          isActive: _currentStep > 0,
        ),
        Step(
          title: Text('Information',
            style: TextStyle(color: Colors.pink,fontFamily: 'Pacifico',fontSize: 25.0)),
            content: _InformationSetup(context),
          isActive: _currentStep > 1,
        ),
        Step(
          title: Text('Complete',
            style: TextStyle(color: Colors.pink,fontFamily: 'Pacifico',fontSize: 25.0)),
          content: Padding(
                    padding: EdgeInsets.only(top:20.0,left: 20.0,right: 40.0),
                                  child: TextField(
                             controller: bioController,
                              decoration: InputDecoration(
                                  hintText: 'Add your bio',
                              ),

                            ),
                  ),
          isActive: _currentStep > 2,
        )
    ];
    return _steps;
  }

  Future getImage() async{

    var image = await ImagePicker.pickImage(source:ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image path : $_image');
    });

  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressImageFile = File('$path/img_$profileID.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));

    setState(() {
     _image = compressImageFile; 
    
    });
     
  }

 Future<String>uploadImage(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("profile_$profileID.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

  
 

  Widget _CircleUploadAvatar(BuildContext context) {
   
    return Container(
      child: Stack(
         children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      
                      child: ClipOval(
                        
                        child: SizedBox(
                          height: 190.0,
                          width: 190.0,
                          child: (_image != null) ? Image.file(_image,fit:BoxFit.fill) :
                          Image.asset('assets/images/facebook-icon.png',fit: BoxFit.fill,),
                          
                        ),
                      ),
                  ),
                ),
                
            ],
            
            ),
 
        
          
          Padding(padding:EdgeInsets.only(left: 190.0,top:140.0),
            child:FlatButton(
              onPressed: (){
                getImage();
              },
              child:Text('+',style:TextStyle(fontSize: 40.0,color:Colors.white)),
              shape: CircleBorder(),
              color:Colors.pink,
              padding: EdgeInsets.all(1.0),

            ),

              
          
          )
              
       ], ),
      
    );
  }


  Widget _InformationSetup(BuildContext context){

    return Stack(
      children: <Widget>[
        
               Column(children: <Widget>[

                Padding(
                    padding: EdgeInsets.only(left: 20.0,right: 40.0),
                                  child: TextField(              
                              controller: nameController,                    
                              decoration: InputDecoration(
                                  hintText: 'Name', 
                              ),
                             
                            ),
                  ),
               
                Padding(
                    padding: EdgeInsets.only(top:20.0,left: 20.0,right: 40.0),
                                  child: TextField(
                              controller: usernameController,                     
                              decoration: InputDecoration(
                                  hintText: 'Username', 
                              ),
                             
                            ),
                  ),
                  //Datepicker birthday
                Padding(
                  padding: EdgeInsets.only(top:20.0,left: 20.0,right: 40.0),
                  child: RaisedButton(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              doneStyle: TextStyle(color: Colors.pink,fontFamily: 'Montseratt',fontSize: 18.0),
                              cancelStyle: TextStyle(color: Colors.pink,fontFamily: 'Montseratt',fontSize: 18.0),
                              itemHeight: 60.0,
                              containerHeight: 300.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime(2019, 12, 31), 
                            onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          bDateYear = date.year;
                          setState(() {});
                        }, 
                        currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.pink,
                                      ),
                                      Text(
                                        " $_date",
                                        style: TextStyle(
                                             color: Colors.pink,
                                            fontFamily: 'Montseratt',
                                           
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontFamily: 'Montseratt',
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                ),
                Padding(
                        padding: EdgeInsets.only(top:20.0,right: 225.0),
                           child: Text(
                          'Gender',
                          style: new TextStyle(
                            fontFamily: 'Montseratt',
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child:new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            activeColor: Colors.pink,
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text(
                            'Male',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          Radio(
                            activeColor: Colors.pink,
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Radio(
                            activeColor: Colors.pink,
                            value: 2,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                            
                          ),
                          Text(
                            'LGBTQ',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),

                ) 
                
            ],),
         

    ],);

  }

  createUser() async{

  

 String mediaURL = await uploadImage(_image);
 final dateNow = DateTime.now().year;
 final ageN = dateNow - bDateYear;

        try{
           await userRef
              .document(id)
              .setData({
                'age':ageN,
                'bio': bioController.text,
                'birtdate': _date,
                'gender': _value,
                'name':nameController.text,
                'profpic':mediaURL,
                'userid':id,
                'username':usernameController.text
              });

      
             setState(() {
           showSpinner=false;
          });

            
            Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) =>LoginPage()));
         
        }catch(e){
          print(e);
        }
     

   
  }

}
