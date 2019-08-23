import 'package:flutter/material.dart';
import 'progressStepCircle.dart';

class SignUpThree extends StatefulWidget {
  @override
  _SignUpThreeState createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
                child: Stack(children: <Widget>[
            
            Column(
             
              children: <Widget>[
                 SizedBox(height: 70.0),
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   SizedBox(width: 0.0,),
                   new StepCircle(txt: '1',
                   padL: 23,
                   padT: 23,
                   padR: 23,
                   padB: 33,
                   color: Colors.pink,),
                  
                  Container(
                    height: 5,
                    width: 70,
                    decoration: BoxDecoration(
                      shape:BoxShape.rectangle,
                      color: Colors.pink,
                    ),
                  ),
                  
                  new StepCircle(txt: '2',
                   padL: 23,
                   padT: 23,
                   padR: 23,
                   padB: 33,
                   color: Colors.pink,),
                    
                   Container(
                    height: 5,
                    width: 70,
                    decoration: BoxDecoration(
                      
                      
                      shape:BoxShape.rectangle,
                     color: Colors.pink,
                      
                      
                    ),
                  ),
           
                  new StepCircle(txt: '3',
                   padL: 23,
                   padT: 23,
                   padR: 23,
                   padB: 33,
                   color: Colors.pink,),
                    SizedBox(width: 1.0),
                    
                ],),
                
                Text('Upload Your Picture',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 30.0,
                  color: Colors.pink
                ), 
              ),
                    Text('You can change everything later',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10.0,
                  color: Colors.grey
                ), 
              ),
                
                  

                 

                
              ],),
          
          ],),
        ),
    );
  }
}