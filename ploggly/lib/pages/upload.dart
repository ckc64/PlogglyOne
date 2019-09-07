import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  selectImage(context){
       
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

  
  @override
  Widget build(BuildContext context) {
          return buildSplashScreen();
    }
  }
