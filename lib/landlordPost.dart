import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import "package:flutter_localizations/flutter_localizations.dart";
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class LandlordPost extends StatefulWidget {
  LandlordPost({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _LandlordPost createState() => _LandlordPost();
}

class _LandlordPost extends State<LandlordPost> {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  TextEditingController addressController;
  TextEditingController bedroomController;
  TextEditingController priceController;
  var dateStart = " ";
  var dateEnd = " ";

  //values for the drop down city choice menu
  var currentSelectedCityValue;
  var cities = ["Guelph", "Other"];

  //values for the drop down city choice menu
  var currentSelectedHouseTypeValue;
  var houseType = ["House", "Townhouse", "Appartment"];

  @override
  initState() {
    addressController = new TextEditingController();
    bedroomController = new TextEditingController();
    priceController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post (landlord)"),
        actions: <Widget>[

        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Material(
            child: Column(
              children: <Widget>[

                SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text("Location", style: style),
                      SizedBox(width: 15.0),
                      DropdownButton<String>(
                        hint: Text("Select City"),
                        value: currentSelectedCityValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedCityValue = newValue;
                          });
                          print(currentSelectedCityValue);
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

                SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text("Property Type", style: style),
                      SizedBox(width: 15.0),
                      DropdownButton<String>(
                        hint: Text("Select type"),
                        value: currentSelectedHouseTypeValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedHouseTypeValue = newValue;
                          });
                          print(currentSelectedHouseTypeValue);
                        },
                        items: houseType.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]
                ),

                SizedBox(height: 20.0),
                TextFormField(
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Address*',
                    hintText: "Ex: 123 Smart Street",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                  ),
                  controller: addressController,
                ),

                SizedBox(height: 15.0),
                TextFormField(
                  style: style,
                  decoration: InputDecoration(
                    labelText: '# Bedrooms*',
                    hintText: "Ex: 4",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                  ),
                  controller: bedroomController,
                ),

                SizedBox(height: 15.0),
                TextFormField(
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Price/month*',
                    hintText: "Ex: 500",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                  ),
                  controller: priceController,
                ),

                SizedBox(height: 15.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.deepOrange,
                        child: MaterialButton(
                          minWidth: 50.0,
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          textColor: Colors.white,
                          onPressed: () {
                            showDatePicker(context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 5),
                            ).then((date) {
                              setState(() {
                                dateStart = "${date.day}-${date.month}-${date.year}";
                              });
                            });
                          },
                          child: Text("Lease Start Date",
                            textAlign: TextAlign.center,
                            style: style,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Text("Start date: $dateStart", style: style),
                    ]
                ),

                SizedBox(height: 15.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.deepOrange,
                        child: MaterialButton(
                          minWidth: 50.0,
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          textColor: Colors.white,
                          onPressed: () {
                            showDatePicker(context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 5),
                            ).then((date) {
                              setState(() {
                                dateEnd = "${date.day}-${date.month}-${date.year}";
                              });
                            });
                          },
                          child: Text("Lease End Date",
                            textAlign: TextAlign.center,
                            style: style,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Text("End date: $dateEnd", style: style),
                    ]
                ),

                SizedBox(height: 20.0),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.deepOrange,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    textColor: Colors.white,
                    onPressed: () {

                      //***do error checking before sending data

                      Firestore.instance.collection("posts").document().setData({
                        "city": currentSelectedCityValue,
                        "house_type": currentSelectedHouseTypeValue,
                        "address": addressController.text,
                        "bedrooms": bedroomController.text,
                        "price": priceController.text,
                        "lease_date_start": dateStart,
                        "lease_date_end": dateEnd,
                      });

                      Navigator.pushNamed(context, "/home");

                    },
                    child: Text("Submit",
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
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

  void onTapBottomNav(int index){
    if(index == 0){
      Navigator.pushNamed(context, "/home");
    }
    else if(index == 1){
      Navigator.pushNamed(context, "/profile");
    }
  }

}