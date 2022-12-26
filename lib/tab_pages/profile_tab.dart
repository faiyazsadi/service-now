import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../global/global.dart';
import '../main.dart';
import '../splash_screen/splash_screen.dart';

class ViewProfile extends StatefulWidget {
  late String name, email, phone, urlImage, type;
  ViewProfile({required this.name, required this.phone, required this.email, required this.urlImage, required this.type});

  @override
  State<ViewProfile> createState() => _ViewProfileState(name, phone, email, urlImage, type);
}

class _ViewProfileState extends State<ViewProfile> {
  late String name, email, phone, urlImage, type;
  _ViewProfileState(this.name, this.email, this.phone, this.urlImage, this.type);
  final formKey = GlobalKey<FormState>(); //key for form

  int x = 1;
  late String imageUrl;
  XFile? image;

  final ImagePicker picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter

  @override

  void initState(){
    super.initState();
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('This is a snackbar')));

          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                  child: Icon(Icons.person)
              );
            },
          ),
          title: Text("Provider Profile",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Ubuntu",
            ),),
          centerTitle: false,
          backgroundColor: Colors.red.shade900,
          foregroundColor: Colors.white,
          elevation: 15,
          toolbarHeight: 60,
          actions: <Widget>[
            IconButton(
              onPressed: (){
                  showDialog(context: context, builder: (BuildContext contest){return AlertDialog(
                    title: Text("Warning !!",
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.red.shade900,
                        fontFamily: "FredokaOne",
                      ),),
                    content: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0, top: 10.0),
                      child: Text('Are you sure to sign out?',
                        style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.black45,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
                            driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
                            fAuth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const MySplashScreen())));
                          },
                          child: Text(
                            "YES",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.shade900,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      TextButton(onPressed:(){
                        Navigator.of(context).pop();
                      },
                          child: Text(
                            "No",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red.shade900,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      SizedBox(width: 0,)
                    ],
                  );});
            },
              icon: Icon(Icons.logout_rounded,
                size: 30,),
              // onPressed: () {
              //   DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
              //   driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
              //   fAuth.signOut();
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: ((context) => const MySplashScreen())));
              // },

            ),
            SizedBox(width: 15,),
          ],
        ),
        backgroundColor: Color(0xFFffffff),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left:10, right: 10),
            child: Column(
              //padding: const EdgeInsets.all(8),
              children: <Widget>[
                SizedBox(height: 55,),
                Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width:2.5, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                          ),
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("images/loading.png"),
                            //backgroundImage: AssetImage('images/service_now_logo.jpeg'),
                            child: Container(
                                child: urlImage != null ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: Image.network(urlImage,
                                      height: 300,
                                      width: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : Icon(Icons.person,
                                  size: 60,
                                  color: Colors.white,)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.red.shade900),
                        )
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('Name',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(name,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ) ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.red.shade900),
                        )
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('Phone',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(phone,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                      ],
                    ) ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.red.shade900),
                        )
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('Email',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(email,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                      ],
                    ) ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.red.shade900),
                        )
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('Provider Type',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(type,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                      ],
                    ) ,
                  ),
                ),
                SizedBox(height: 60,),
            ]
          ),
          ),
        ),
      ),
    );
  }
}

