import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:ploggly/loginpages/style/theme.dart' as Theme;

import 'package:ploggly/loginpages/utils/bubble_indication_painter.dart';
import 'package:ploggly/pages/home.dart';
import 'package:ploggly/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'firsttime_page.dart';

class LoginPage extends StatefulWidget {
 
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.white;
  Color right = Colors.pink;

//firebase
  final fAuth = FirebaseAuth.instance;
  final fStore = Firestore.instance;
  
  bool showSpinner = false;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body:ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Text(
                        'ploggly',
                        style: TextStyle(
                            color: Colors.pink,
                            fontFamily: 'Pacifico',
                            fontSize: 35.0),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.pink;
                            left = Colors.white;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.pink;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }



  @override
  void initState() {

    
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
   
  }

  void showDialogAlert(String txt) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text(txt),
        );
      },
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left, fontSize: 16.0, fontFamily: "Montseratt"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right, fontSize: 16.0, fontFamily: "Montseratt"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
 
  Widget _buildSignIn(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 23.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                // Card(

                // color: Colors.white,

                // child:
                Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.pink,
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "Montserrat", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "Montseratt",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.pink,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "Montserrat", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 170.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    gradient: new LinearGradient(
                        colors: [
                          Colors.pink,
                          Colors.pink,
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.pink,
                      //splashColor: Theme.Colors.loginGradientEnd,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "Montseratt"),
                        ),
                      ),
                      onPressed: () async{
                          String email = loginEmailController.text;
                          String password = loginPasswordController.text;

                       
                          
                        if(email.isEmpty || password.isEmpty){
                            showDialogAlert('Email or password is empty');
                        }else{
                        
                          try{
                            setState(() {
                              showSpinner=true;
                              });
                              FirebaseUser user = await fAuth.signInWithEmailAndPassword(email: email,password: password);
                           
                           
                              FirebaseUser willLoggedInUser = await fAuth.currentUser();
                              String userid =  willLoggedInUser.uid;
                              
                            
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if(user != null){                   
                                  prefs.setString("email", email);
                                  prefs.setString("uid", userid);
                                  prefs.setString("password", password);
                                  
                                    await userRef.document(userid)
                              .get().then((doc){
                                 
                                     if(doc.exists){
                                        if(doc["age"] == "" || doc["bio"] == "" || doc["birthdate"]
                                        == doc["gender"] || doc["name"] == "" || doc["profpic"] == ""
                                        || doc["userid"] == ""|| doc["username"] == ""){
                                              Navigator.pushReplacement(context, 
                                            MaterialPageRoute (builder: (context) => FirsTimePage()));
                                          setState(() {
                                            showSpinner=false;
                                          });
                                        }else{
                                            Navigator.pushReplacement(context, 
                                            MaterialPageRoute (builder: (context) => Homepage(userID:userid)));
                                          setState(() {
                                            showSpinner=false;
                                          });
                                        }

                                       

                                     }else{
                                       print("No document $userid");
                                     }
                                  
                              });
   
                                  
                              }

                              
                              
                          }on PlatformException{
                             showDialogAlert('Email or Password is incorrect');
                          }
                          
                        }
                    }
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontFamily: "Montserrat"),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.grey[300],
                            Colors.grey,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontFamily: "Montseratt"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.grey,
                            Colors.grey[300],
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 40.0),
                  child: GestureDetector(
                    onTap: () => showInSnackBar("Facebook button pressed"),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: new Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () => showInSnackBar("Google button pressed"),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: new Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
     
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 23.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding:EdgeInsets.only(left:20.0),
                          child: Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
           
                  Container(
                    width: 300.0,
                    height: 360.0,
                    child: Column(
                      
                      children: <Widget>[
                       
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeEmail,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.pink,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.pink,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.pink,
                              ),
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //),
                  Container(
                      margin: EdgeInsets.only(top: 270.0),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.pink,
                              Colors.pink,
                            ],
                            begin: const FractionalOffset(0.2, 0.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: "Montseratt"),
                          ),
                        ),
                        onPressed: () async {
                             
                          String email = signupEmailController.text,
                              password = signupPasswordController.text,
                              confirmpass = signupConfirmPasswordController.text;
                              

                          if (email.isEmpty ||
                              password.isEmpty ||
                              confirmpass.isEmpty 
                             ) {
                            showDialogAlert('Please fill all the fields');
                          } else if (password != confirmpass) {
                            showDialogAlert('Confirm password does not match');
                          } else if (password.length < 6) {
                            showDialogAlert('Password must be 6 characters and above');
                          }else{

                              
                            try{
                              setState(() {
           showSpinner=true;
          });
                              final newUser = await fAuth.createUserWithEmailAndPassword(
                              email: email, password: confirmpass);
                              FirebaseUser firebaseUser = await fAuth.currentUser();
                            String id = firebaseUser.uid;
                            userRef.document(id).setData({
                                    
                                      'age':"",
                                      'bio': "",
                                      'birtdate': "",
                                      'gender': "",
                                      'name':"",
                                      'profpic':"",
                                      'userid':"",
                                      'username':""
                                   
                            });
                              
                              if(newUser != null){
                                 
                                  Navigator.pushReplacement(context,
                                    MaterialPageRoute (builder: (context)=>FirsTimePage())
                                  );
                                  
                                 setState(() {
           showSpinner=false;
          });
                              }     

                                                 

                            }on PlatformException{
                                showDialogAlert('Email is Already in use');
                            }
                          }
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      );

  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
