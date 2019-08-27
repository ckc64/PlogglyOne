
import 'package:flutter/material.dart';
import 'package:ploggly/firstimepages/steptwopage.dart';
import 'progressStepCircle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'customradio.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpOnePage extends StatefulWidget {  

  @override
  _SignUpOnePageState createState() => _SignUpOnePageState();
}


class _SignUpOnePageState extends State<SignUpOnePage> with SingleTickerProviderStateMixin {

  FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
    void getCurrentUser() async{
        final user = await fAuth.currentUser();
        if(user != null){
          loggedInUser = user;
        }

    }

   


  @override
  void initState() { 
    super.initState();
      getCurrentUser();
     
  }

 // state variable
 int _radioValue = 0;
  String _value = '';
  
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
  
  



 String _date = "Birthday";

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
                    color: Colors.grey[100],
                  ),
                ),
                
                new StepCircle(txt: '2',
                 padL: 23,
                 padT: 23,
                 padR: 23,
                 padB: 33,
                 color: Colors.grey[100],),
                  
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
              
              Text('Personal Information',
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
                  padding: EdgeInsets.only(left: 20.0,right: 40.0),
                                child: TextField(
                            keyboardType:TextInputType.emailAddress,
                           onChanged: (value){
                              
                           },                      
                            decoration: InputDecoration(
                                hintText: 'Name', 
                            ),
                           
                          ),
                ),
             
              Padding(
                  padding: EdgeInsets.only(top:20.0,left: 20.0,right: 40.0),
                                child: TextField(
                            keyboardType:TextInputType.emailAddress,
                           onChanged: (value){
                              
                           },                      
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
                        padding: EdgeInsets.only(top:20.0,right: 325.0),
                           child: Text(
                          'Gender',
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
                  padding: EdgeInsets.only(left: 20.0,right: 40.0),
                                child: TextField(
                            keyboardType:TextInputType.number,
                           onChanged: (value){
                              
                           },                      
                            decoration: InputDecoration(
                                hintText: 'Mobile Number', 
                            ),
                           
                          ),
                ),


                Container(
                     
                      margin: EdgeInsets.only(top:30.0),
                      padding: EdgeInsets.only(left: 40.0,right:40.0),
                      child:ButtonTheme(
                        height: 55.0,
                        
                        child: RaisedButton(
                      onPressed: (){
                          String id = loggedInUser.uid;
                          print('USER ID : $id');
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpTwo()));
                          
                      },
                      color: Colors.pink,
                      animationDuration: Duration(seconds: 10),
                      elevation: 7,
                      
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
      )
    );
  }
}
