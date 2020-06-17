import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lordz/home.dart';

//create _LoginPageState
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

//_LoginPageState class
class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  void errorMessage(){
//    log("SHOW DIALOG");
    showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          title: new Text("Login failed"),
          content: new Text("Check email and/or password"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ]
        );
      }
    );
  }

    //function to determine if the email is a valid format
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  //function to determine if password is at least 8 characters
  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be 8 characters or longer';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 35.0),
                  //hand and key image
                  SizedBox(
                    height: 225.0,
                    child: Image.asset(
                      "assets/rentLogo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 35.0),

                  TextFormField(
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Email*',
                      hintText: "john.doe@gmail.com",
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    //textFormField is better than TextField() because it allows for the validator
                    validator: emailValidator,
                  ),

                  SizedBox(height: 25.0),

                  TextFormField(
                    style: style,
                    decoration: InputDecoration(
                        labelText: 'Password*',
                        hintText: "********",
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),

                  SizedBox(height: 25.0),

                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: Text(
                        "Login",
                        style: style,
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        log("Login loading");
                        //This block takes care of all the authentication
                        if (_loginFormKey.currentState.validate()) {
                          //Firebase auth sign in function
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => Firestore.instance.collection("users").document(currentUser.uid).get()

                                  .then((DocumentSnapshot result) =>
                                      //building the home page with the user's name, CHANGE HERE
                                      Navigator.pushReplacement(context, MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            title: "Home", //result["fname"] + "'s Tasks",
                                            uid: currentUser.uid))))

                                  .catchError( (err) => errorMessage() ) )
                              .catchError( (err) => errorMessage() );

//                                  .catchError((err) => print(err)))
//                              .catchError((err) => print(err));
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 100.0),

                  Text(
                    "New user? Click here",
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),

                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.deepOrange,
                    child: MaterialButton(
                      minWidth: 50.0,
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text("Create Account",
                          textAlign: TextAlign.center,
                          style: style,
                      ),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
