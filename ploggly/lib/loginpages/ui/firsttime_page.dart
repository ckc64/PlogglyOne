import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirsTimePage extends StatefulWidget {
  @override
 _FirsTimePageState createState() => _FirsTimePageState();
}

class _FirsTimePageState extends State<FirsTimePage> {

  int _currentStep =0;
  File _image;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  SingleChildScrollView(
                  child: Column(
                    
            children: <Widget>[
               Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: Text(
                          'Setup Account',
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
      
                ),
            ],
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
            content: TextField(),
          isActive: _currentStep > 1,
        ),
        Step(
          title: Text('Complete',
            style: TextStyle(color: Colors.pink,fontFamily: 'Pacifico',fontSize: 25.0)),
          content: TextField(),
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

}
