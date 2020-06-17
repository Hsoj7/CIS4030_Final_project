import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  //declaring variables
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  FirebaseUser user;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  final TextStyle style2 = TextStyle(fontFamily: 'Montserrat', fontSize: 24.0);
  String userID;
  TextEditingController _bioController = TextEditingController(text: "Write bio here");
  var query;
  var test;
  FirebaseStorage _storage = FirebaseStorage.instance;

  //constructor
  @override
  initState() {
    this.getCurrentUser();
    this.getProfilePic();
    super.initState();
  }

  //get user information from firebase
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    user = await auth.currentUser();
    userID = user.uid;

    //gets the user's bio and puts it in text controller
    Firestore.instance.collection('users').document(userID).get().then((DocumentSnapshot ds) {
      _bioController.text = ds.data['bio'];
    });

    //NEED SET STATE HERE TO REFERSH WHEN THE SHIT ABOVE RETURNSSSSSS. FUCK MY LIFE THIS TOOK SO LONG
    setState(() {

    });
  }

  //eventually will use this for getting the user's profile picture
  void getProfilePic() async {
//    var ref = _storage.ref().child("/profile_pictures/$userID");
//    var url = await ref.getDownloadURL() as String;
//    log("URL::::::" + url);
  }


//  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //this removes the stupid back button
        automaticallyImplyLeading: false,
        title: Text("Profile page"),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
            key: _profileKey,
            child: Column(
              children: <Widget>[
//              SizedBox(height: 10.0),

                //icon button where profile picture will go
                IconButton(
                  iconSize: 150.0,
                  icon: Icon(
                    Icons.account_circle,
                    semanticLabel: 'Account Button',
                  ),
                  onPressed: () {
                    log("Profile edit clicked");
                    uploadPic();
                    //edit profile picture code goes here
                  },
                ),

                //Rating code, just hard coded for now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
  //                  Text(
  //                    "Rating: ",
  //                    style: style2,
  //                  ),
                    Icon(
                      Icons.star,
                      semanticLabel: 'Account Button',
                      color: Colors.yellow[700],
                    ),
                    Icon(
                      Icons.star,
                      semanticLabel: 'Account Button',
                      color: Colors.yellow[700],
                    ),
                    Icon(
                      Icons.star,
                      semanticLabel: 'Account Button',
                      color: Colors.yellow[700],
                    ),
                    Icon(
                      Icons.star,
                      semanticLabel: 'Account Button',
                      color: Colors.yellow[700],
                    ),
                    Icon(
                      Icons.star_half,
                      semanticLabel: 'Account Button',
                      color: Colors.yellow[700],
                    ),
                  ],
                ),

                SizedBox(height: 30.0),

                //gets first name and last name
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userID).snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot){
                    if(snapshot.connectionState != ConnectionState.active) return Text("Loading...");
                    else if(snapshot.connectionState == ConnectionState.active) {
                      return Row(
                        children: <Widget>[
                          Text(
                            "Name: ",
                            style: style,
                          ),
                          Text(
                            snapshot.data['fname'] + " " +
                                snapshot.data['surname'],
                            style: style,
                          ),
                        ],
                      );
                    }
                  },
                ),

                SizedBox(height: 15.0),

                //gets user id
                Row(
  //                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "User ID: ",
                      style: style,
                    ),
                    Text(
                      userID??"Loading...",
                      style: style,
                    ),
                  ],
                ),

                SizedBox(height: 15.0),

                //Gets account type: tenant/landlord
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userID).snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot){
                    if(snapshot.connectionState != ConnectionState.active) return Text("Loading...");
                    else if(snapshot.connectionState == ConnectionState.active) {
                      return Row(
  //                    mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Acocunt type: ",
                            style: style,
                          ),
                          Text((() {
                            if(snapshot.data['AcctType'] == 1){
                              return "Tenant";
                            }
                            else{
                              return "Landlord";
                            }
                          })(),
                              style: style),
                        ],
                      );
                    }
                  }
                ),

                SizedBox(height: 30.0),

                //controls bio and talks with firebase to make it persistant storage
                TextField(
                  maxLines: 5,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    hintText: "Bio goes here",
                    hintMaxLines: 5,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                  ),
                  controller: _bioController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value){
                    Firestore.instance.collection("users").document(userID).updateData({
                      "bio": _bioController.text,
                    });
                  },
                ),

                SizedBox(height: 20.0),

                //logout button
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.red,
                  child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB
                  (20.0, 15.0, 20.0, 15.0),
                  child: Text(
                    "Logout",
                    style: style,
                  ),
                  textColor: Colors.black,
                  onPressed: () {
                    FirebaseAuth.instance.signOut()
                        .then((result) => Navigator.pushReplacementNamed(context, "/login")).catchError((err) => print(err));
                  },
                ),
              ),


            ],

          ),
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        onTap: onTapBottomNav,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.home, 
              color: Colors.grey[600],
            ),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Profile",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ]
      ),
    );
  }

  //helper functions
  void onTapBottomNav(int index){
    if(index == 0){
      Navigator.pushNamed(context, "/home");
    }
    else if(index == 1){
      log("Already on profile page");
    }
  }

  //image picker widget
  void uploadPic() async {
    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("$userID/profile_pic");
    //Upload the file to firebase
    reference.putFile(image);
  }
}
