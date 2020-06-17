import 'dart:developer';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //declare variables
  FirebaseUser currentUser;
  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;
  String userID;
  var accountType = 0;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

  final TextStyle styleHeader = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold);

  TextEditingController controller = new TextEditingController();
  String search;
  String filterOptions;
  var currentSelectedValue;
  var cities = ["Guelph", "Other"];
  var isCheckedHouse = true;
  var isCheckedRoommate = true;
  RangeValues _values = RangeValues(1, 5);

  var list;
  List<String> items = List<String>();

  //constructor
  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  //gets data for user from firebase
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    user = await auth.currentUser();
    userID = user.uid;

    Firestore.instance.collection('users').document(userID).get().then((DocumentSnapshot ds) {
      accountType = ds.data['AcctType'];
    });

  }

  // ignore: missing_return
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qs = await firestore.collection("posts").getDocuments();
    return qs.documents;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //this removes the stupid back button
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: <Widget>[

          //new post button on top right
          RaisedButton(
            onPressed: () {
              if(accountType == 1){
                //go to user post page
                log("Tenant");
                showAlertDialog(context);
              }
              else if(accountType == 2){
                //go to landlord post page
                log("Lord");
                Navigator.pushNamed(context, "/landlordPost");
              }
              else{
                //do nothing because it didn't get the user's account type yet
              }
            },
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(10.0),
            child: Row( // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 35.0,
                  color: Colors.white,
                ),
                Text(
                  "New Post",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
          ),


        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
        child: Material(
          child: Column(
            children: <Widget>[


              //filter options
              ExpansionTile(
                title: Text("Filters"),
                backgroundColor: Colors.grey[200],
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text("Location", style: style),
                      SizedBox(width: 15.0),
                      DropdownButton<String>(
                        hint: Text("Select City"),
                        value: currentSelectedValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedValue = newValue;
                          });
                          print(currentSelectedValue);
                        },
                        items: cities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text("Listings", style: style),
                      Checkbox(
                        value: isCheckedHouse,
                        onChanged: (value) {
                          setState(() {
                            isCheckedHouse = value;
                            log("house = $isCheckedHouse");
                          });
                        },
                      ),
                    ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text("Roommates", style: style),
                      Checkbox(
                        value: isCheckedRoommate,
                        onChanged: (value) {
                          setState(() {
                            isCheckedRoommate = value;
                            log("roommate = $isCheckedRoommate");
                          });
                        },
                      ),
                    ]
                  ),


                  SizedBox(height: 20.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.deepOrange,
                    child: MaterialButton(
                      minWidth: 100.0,
                      height: 5,
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      textColor: Colors.white,
                      onPressed: () {
                        //Update listings

                      },
                      child: Text("Apply",
                        textAlign: TextAlign.center,
                        style: style,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),
                ]
              ),

              SizedBox(height: 10.0),

              //search bar
              TextFormField(
                style: style,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: "",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                ),
                controller: controller,
              ),

              SizedBox(height: 10.0),
              //put posts here

              // ignore: missing_return
              //All the code to build the list of postings
              SizedBox(
                height: 450.0,
                child: FutureBuilder(
                  future: getPosts(),
                    // ignore: missing_return
                    builder: (_, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Text("Loading...");
                  }
                  else{
                    // ignore: missing_return
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      // ignore: missing_return
                      itemBuilder: (_, index){
                        return Card(
                          child: Column( // Replace with a Row for horizontal icon + text
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data[index].data['house_type'], style: styleHeader),
                              SizedBox(height: 20.0),
                              Text("Location: " + snapshot.data[index].data['city']),
                              SizedBox(height: 5.0),
                              Text("Address: " + snapshot.data[index].data['address']),
                              SizedBox(height: 5.0),
                              Text("# of Bedrooms: " + snapshot.data[index].data['bedrooms']),
                              SizedBox(height: 5.0),
                              Text("Price: \$" + snapshot.data[index].data['price'].toString()),
                              SizedBox(height: 10.0),
                            ]

                          ),
                        );
                      }
                    );

                  } //else
                }),

              ),

            ],
          ),
        ),
      ),
      ),
      //bottom nav bar with home/profile page
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[300],
          onTap: onTapBottomNav,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.account_circle,
                color: Colors.grey[600],
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ]
      ),
    );
  }

  //helper functions
  void onTapBottomNav(int index){
    if(index == 0){
      log("Already on home page");
    }
    else if(index == 1){
      Navigator.pushNamed(context, "/profile");
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coming soon"),
      content: Text("Feature coming soon"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
