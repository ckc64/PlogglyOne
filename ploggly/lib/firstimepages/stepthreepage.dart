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
               
            
               
                 Column(
                   children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.only(top:270),
                       child: Center(

                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/facebook-icon.png'),
                          minRadius: 50,
                          maxRadius: 100,
                          
                        ),),
                     ),

                     
                   ],
                 ),
            
              
                Padding(
                  padding: const EdgeInsets.fromLTRB(230.0,410.0,0,0),
                  child: RawMaterialButton(
                      onPressed: () {},
                      child: new Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.pink,
                      padding: const EdgeInsets.all(10.0),
                    ),
                ), 

                Padding(
                  padding: EdgeInsets.only(left: 20.0,right: 40.0,top:500),
                                child: TextField(
                            keyboardType:TextInputType.multiline,
                            maxLines: 3,
                           onChanged: (value){
                              
                           },                      
                            decoration: InputDecoration(
                                hintText: 'Bio', 
                              
                                
                            ),
                            
                           
                          ),
                ),

                 Container(
                       
                        margin: EdgeInsets.only(top:30.0),
                        padding: EdgeInsets.only(left: 40.0,right:40.0,top: 570),
                        child:ButtonTheme(
                          height: 55.0,
                          
                          child: FlatButton(
                        onPressed: (){

                           Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpThree()));
                            
                        },
                        color: Colors.pink,
                       
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          
                        ),
                        child: Center(child: 
                            Text('Finish',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),

                            ),
                            ),
                      ),
                        ),
                        
                      ),

                
          ],),
        ),
    );
  }
}