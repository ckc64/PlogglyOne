import 'package:flutter/material.dart';
import 'package:ploggly/firstimepages/stepthreepage.dart';
import 'progressStepCircle.dart';

class SignUpTwo extends StatefulWidget {
  @override
  _SignUpTwoState createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {

// state variable
 int _radioValue = 0;
  String _value = '';
  double rangeValue = 18;
  int ageGap;
  bool allowed = false;
  
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
                     color: Colors.grey[100],
                      
                      
                    ),
                  ),
           
                  new StepCircle(txt: '3',
                   padL: 23,
                   padT: 23,
                   padR: 23,
                   padB: 33,
                   color: Colors.grey[100],),
                    SizedBox(width: 1.0),
                    
                ],),
                
                Text('Preferences',
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
                
                  

                  Padding(
                        padding: EdgeInsets.only(top:20.0,right: 280.0),
                           child: Text(
                          'Interested in',
                          style: new TextStyle(
                            fontFamily: 'Montseratt',
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      new Row(
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
                            style: new TextStyle(fontSize: 16.0),
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
                              fontSize: 16.0,
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
                            style: new TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),

                       Padding(
                        padding: EdgeInsets.only(top:20.0,right: 150.0),
                           child: Text(
                          'Age gap you interested 18-$ageGap',
                          style: new TextStyle(
                            fontFamily: 'Montseratt',
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                      ),

                      Padding(
                        
                        padding: EdgeInsets.only(top:20.0,left:10.0,right: 10.0),
                           child: Slider(
                             value: rangeValue,
                             min: 18,
                             max: 65,
                             activeColor: Colors.pink,
                             inactiveColor: Colors.grey,
                             onChanged: (changedValue){
                               setState(() {
                                 rangeValue = changedValue;
                               });
                               ageGap=changedValue.round();
                               print(changedValue.round());
                             },
                           ),
                      ),

                            Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            
                            Checkbox(
                                value: allowed,
                                activeColor: Colors.pink,
                                onChanged: (bool value) {
                                    setState(() {
                                        allowed = value;
                                    });
                                },
                            ),
                            Text('Allow',
                            style: TextStyle(
                              fontFamily: 'Montseratt',
                              fontSize: 20.0,
                              color: Colors.grey,

                            ),),
                            Text(' ploggy ',
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.pink,

                            ),),
                            Text('to access your location.',
                            style: TextStyle(
                              fontFamily: 'Montseratt',
                              fontSize: 20.0,
                              color: Colors.grey,

                            ),)
                        ],
                    ),

                  Container(
                       
                        margin: EdgeInsets.only(top:30.0),
                        padding: EdgeInsets.only(left: 40.0,right:40.0),
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
                            Text('PROCEED',
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
          
          ],),
        ),
    );
  }
}
