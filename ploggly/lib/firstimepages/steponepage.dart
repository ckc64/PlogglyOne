
import 'package:flutter/material.dart';
import 'progressStepCircle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'customradio.dart';


class SignUpOnePage extends StatefulWidget {
  @override
  _SignUpOnePageState createState() => _SignUpOnePageState();
}


class _SignUpOnePageState extends State<SignUpOnePage> with SingleTickerProviderStateMixin {

  



 String _date = "Birthday";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        
        Column(
         
          children: <Widget>[
             SizedBox(height: 100.0),
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
             
             
          ],),

      ],)
    );
  }
}
