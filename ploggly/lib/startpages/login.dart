
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ploggly/firstimepages/steponepage.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
  
class _LoginPageState extends State<LoginPage> {

  final fAuth = FirebaseAuth.instance;
  String email, password;



  @override
  Widget build(BuildContext context) {
    
          return Scaffold(
        resizeToAvoidBottomPadding: false,
        
        body: SingleChildScrollView(
                  child: Form(
          
                    child: Stack(children: <Widget>[
                
                Container(
                  alignment: FractionalOffset.topCenter,
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text('ploggly.',
                  style: TextStyle(
                    color: Colors.pink,
                    fontFamily: 'Pacifico',
                    fontSize: 35.0
                  ),
                  ),
                ),
                Column(
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:180.0,left: 40.0,right:40.0),
                    child: TextField(
                      keyboardType:TextInputType.emailAddress,
                     onChanged: (value){
                        email = value.trim();
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
                      
                     onChanged: (value){
                        password = value.trim();
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
                          suffixIcon: Icon(Icons.visibility_off,
                          color: Colors.pink),
                      ),
                       
                    ),
                  ), 
                    SizedBox(height: 10.0),


                         Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.pink,
                            fontFamily: 'Montserrat',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      

                    
                    Container(
                     
                      margin: EdgeInsets.only(top:10.0),
                      padding: EdgeInsets.only(left: 40.0,right:40.0),
                      child:ButtonTheme(
                        height: 55.0,
                        
                        child: RaisedButton(
                      onPressed: ()async{

                          try{

                            final user = await fAuth.signInWithEmailAndPassword(email: email, password: password);
                            if(user !=null){
                              Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context)=> SignUpOnePage ()));
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
                          Text('LOG IN',
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
                    
                  
                     SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        'or connect with',
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
                      child:Text('Don\'t have an account yet?',
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
                              MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                         child: Text('Sign up here',
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
                
              ],
            ),
          ),
        ), 
      );
  
  }
  void gotoHome(){
      //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

