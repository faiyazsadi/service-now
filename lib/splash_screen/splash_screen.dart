import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:service_now/authentication/login_screen.dart';
import 'package:service_now/authentication/phone_number.dart';
import 'package:service_now/global/global.dart';
import 'package:service_now/main_screen/main_screen.dart';
import 'dart:io';

import '../authentication/sign_up_screen.dart';
import '../tab_pages/profile_tab.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      // send user to main screen
      if (fAuth.currentUser != null) {
        currentFirebaseuser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => MainScreen())));
            DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
            driversRef.child(currentFirebaseuser!.uid).update({"isActive": true});
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => Phone())));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(const Duration(seconds: 3), (){
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    // }
    // );
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black, spreadRadius: 1)],
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/service_now_logo.jpeg'),
                  radius: 50.0,
                ),
              ),
              const SizedBox(height: 30,),
              Text("SERVICE NOW",
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'FredokaOne',
                ),
              ),
              SizedBox(height: 20,),
              Text("Provider App",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "FredokaOne",
              ),),
              const SizedBox(height: 60),
              SpinKitFoldingCube(
                color: Colors.white,
                size: 50.0,
              ),
            ],
          ),
        )
    );
  }
}


//Home page
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String verify="";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController countrycode = TextEditingController();
  var phone="";
  @override
  void initState(){
    countrycode.text = "+880";
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(height: 150.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 1)],
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/service_now_logo.jpeg'),
                  radius: 50.0,
                ),
              ),
              SizedBox(height: 25.0,),
              Text(
                "Service Now",
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                "Driver App",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
              SizedBox(height: 40.0),
              Text('Enter your Phone number',
                style: TextStyle(
                  fontSize: 22.0,
                ),),
              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                Container(
                  child: TextField(
                    onChanged: (value){
                      phone = value;
                    },
                    keyboardType: TextInputType.phone,
                    autofocus: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB71C1C),
                          width: 3.0,
                        ),
                      ),
                      labelText: '+880  | ',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                      hintText: 'Enter next 10 digit (e.g.1xxxxxxxxx)',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              FloatingActionButton(onPressed: () async {
                // await FirebaseAuth.instance.verifyPhoneNumber(
                //   phoneNumber: '${countrycode.text + phone}',
                //   verificationCompleted: (PhoneAuthCredential credential) {},
                //   verificationFailed: (FirebaseAuthException e) {},
                //   codeSent: (String verificationId, int? resendToken) {
                //     Home.verify = verificationId;
                //     print(countrycode.text + phone);
                //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyOtp(phone : countrycode.text + phone)));
                //   },
                //   codeAutoRetrievalTimeout: (String verificationId) {},
                // );


                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(phone: "+8801881445979")));
              },
                backgroundColor: Colors.red[900],
                child: const Icon(Icons.navigate_next_rounded),
              ),
            ],
          )
      ),
    );
  }
}




