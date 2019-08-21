
import 'package:flutter/material.dart';
import 'package:ploggly/firstimepages/steponepage.dart';
import 'package:ploggly/startpages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final fAuth = FirebaseAuth.instance;

  String _email,_password,_confirmPassword,_username;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
        body: Form(
                  child: SingleChildScrollView(
                    child: Stack(
              children: <Widget>[
                 Container(
                    alignment: FractionalOffset.topCenter,
                    padding: EdgeInsets.only(top: 90.0),
                    child: Text('Sign Up.',
                    style: TextStyle(
                      color: Colors.pink,
                      fontFamily: 'Pacifico',
                      fontSize: 35.0
                    ),
                    ),
                  ),

                  Column(children: <Widget>[

                     Padding(
                  padding: EdgeInsets.only(top:180.0,left: 40.0,right:40.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                   onChanged:(value){
                      _email = value.trim();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5,color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email,
                        color: Colors.pink
                        ),
                    ),
                  ),
                ),

                
                 Padding(
                  padding: EdgeInsets.only(top:10.0,left: 40.0,right:40.0),
                  child: TextField(
                    onChanged:(value){
                      _password = value.trim();
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.3,color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.pink
                        ),
                        
                    ),
                  ),
                ), 

                Padding(
                  padding: EdgeInsets.only(top:10.0,left: 40.0,right:40.0),
                  child: TextField(
                    
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.3,color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                        hintText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.pink
                        ),
                        
                    ),
                  ),
                ), 
                Container(
                 
                  margin: EdgeInsets.only(top:10.0),
                  padding: EdgeInsets.only(left: 40.0,right:40.0),
                  child:ButtonTheme(
                    height: 55.0,
                    
                    child: RaisedButton(
                  onPressed: () async{
                      try{
                        //final newUser =
                        final newUser = await fAuth.createUserWithEmailAndPassword(email: _email, password: _password);
                        print('$_email and $_password is registered');
                       if(newUser!=null) {
                         Navigator.push(context, MaterialPageRoute(
                             builder: (context) =>  SignUpOnePage ()));
                       }
                      }catch(e){
                        print(e);
                      }

                  },
                  color: Colors.pink,
                  animationDuration: Duration(seconds: 10),
                  elevation: 7,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    
                  ),
                  child: Center(child: 
                      Text('SIGN UP',
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
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'or sign up using',
                    style:TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey
                      ),
                  ),
                ),
                 SizedBox(height: 15.0,),
                    Container(
                     
                      padding: EdgeInsets.only(left: 40.0,right:40.0),
                      child: ButtonTheme(
                        height: 55.0,
                        child:RaisedButton(
                          onPressed: (){},
                          color: Colors.blue,
                          animationDuration: Duration(seconds: 10),
                          elevation: 7,
                      
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                              
                            ),
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: <Widget>[
                              
                                Center(
                                  child: ImageIcon(AssetImage('assets/images/facebook-icon.png'),color: Colors.white,),
                                ),
                                SizedBox(width: 10.0,),
                                Center(
                                  child: Text('FACEBOOK',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color:Colors.white,
                                      fontFamily: 'Montserrat'
                                    ),  
                                  ),
                                ),
                            ],),
                          ),
                        ),

                    ),
                      SizedBox(height: 15.0,),
                    Container(
                     
                      padding: EdgeInsets.only(left: 40.0,right:40.0),
                      child: ButtonTheme(
                        height: 55.0,
                        child:RaisedButton(
                          onPressed: (){},
                          color: Colors.red,
                          animationDuration: Duration(seconds: 10),
                          elevation: 7,
                      
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                              
                            ),
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: <Widget>[
                              
                                Center(
                                  child: ImageIcon(AssetImage('assets/images/google-icon.png'),color: Colors.white,),
                                ),
                                SizedBox(width: 10.0,),
                                Center(
                                  child: Text('GOOGLE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color:Colors.white,
                                      fontFamily: 'Montserrat'
                                    ),  
                                  ),
                                ),
                            ],),
                          ),
                        ),

                    ),
                              
                  SizedBox(height: 10.0,),
                Center(
                  child:Text('Already have an account?',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color:Colors.grey,

                      ),
                  ),
                ),
                  SizedBox(height: 10.0,),
                 Center(
                  
                 
                    child:InkWell(
                      splashColor: Colors.transparent,
                        onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      child: Text('Login here',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                        color:Colors.pink,

                        ),
                  ),
                    ), 
                  
                  
                ),
                  ],),
                  
                  
              ],),
          ),
        )
    );
  }
}