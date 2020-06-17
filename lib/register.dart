import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lordz/home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  final TextStyle style2 = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'ONE';
  // Group Value for Radio Button.
  int acctType = 1;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  //function to display error box
  void errorMessage(){
//    log("SHOW DIALOG");
    showDialog(
        context: context,
        builder:(BuildContext context){
          return AlertDialog(
              title: new Text("Login failed"),
              content: new Text("Email may already exist"),
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

  //function to determine valid email
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

  //function to determine if strong password
  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[

                  TextFormField(
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'First Name*',
                      hintText: "John",
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    controller: firstNameInputController,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid first name.";
                      }
                    },
                  ),

                  SizedBox(height: 30.0),

                  TextFormField(
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Last Name*',
                      hintText: "Doe",
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    controller: lastNameInputController,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid last name.";
                      }
                    }
                  ),

                  SizedBox(height: 30.0),

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
                    validator: emailValidator,
                  ),

                  SizedBox(height: 30.0),

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

                  SizedBox(height: 30.0),

                  TextFormField(
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password*',
                      hintText: "********",
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),

                  SizedBox(height: 30.0),

//                  RadioGroup(),
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Account Type:',
                      style: style2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: acctType,
                        onChanged: (val) {
                          setState(() {
//                            log("Tenant");
                            radioButtonItem = 'ONE';
                            acctType = 1;
                          });
                        },
                      ),
                      Text(
                        'Tenant',
                        style: style,
                      ),

                      Radio(
                        value: 2,
                        groupValue: acctType,
                        onChanged: (val) {
                          setState(() {
//                            log("Landlord");
                            radioButtonItem = 'TWO';
                            acctType = 2;
                          });
                        },
                      ),
                      Text(
                        'Landlord',
                        style: style,
                      ),

                    ],
                  ),

                  SizedBox(height: 30.0),

                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: Text(
                        "Register",
                        style: style,
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        if (_registerFormKey.currentState.validate()) {
                          //make sure passwords match
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance.collection("users").document(currentUser.uid).setData({
                                      "uid": currentUser.uid,
                                      "fname": firstNameInputController.text,
                                      "surname": lastNameInputController.text,
                                      "email": emailInputController.text,
                                      "AcctType": acctType,
                                    })
                                    .then((result) => {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                        title: "Home", //firstNameInputController.text + "'s Tasks",
                                                        uid: currentUser.uid,
                                                      )),
                                              (_) => false),
                                          firstNameInputController.clear(),
                                          lastNameInputController.clear(),
                                          emailInputController.clear(),
                                          pwdInputController.clear(),
                                          confirmPwdInputController.clear()
                                        })
                                    .catchError((err) => errorMessage() ))
                                .catchError((err) => errorMessage() );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("The passwords do not match"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                     },
                    ),
                  ),
                ],
              ),
            ))));
  }
}