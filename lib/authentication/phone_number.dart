import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:service_now/authentication/sign_up_screen.dart';
import 'package:service_now/main_screen/main_screen.dart';
import 'package:service_now/splash_screen/splash_screen.dart';
import 'package:service_now/tab_pages/home_tab.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'car_info_screen.dart';
import 'otp_input.dart';


class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);
  static String verify="";
  @override
  State<Phone> createState() => _PhoneState();
}
class _PhoneState extends State<Phone> {
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
              SizedBox(height: 30.0,),
              Text(
                "Service Now",
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Provider App",
                style: TextStyle(
                  fontSize: 22.0,
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
                      print(phone);
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
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '${countrycode.text + phone}',
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    Home.verify = verificationId;
                    print(countrycode.text + phone);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyOtp(phone : countrycode.text + phone)));
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(phone : countrycode.text + phone)));
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
                 Navigator.push(context, MaterialPageRoute(builder: ((context) => MyOtp(phone : countrycode.text + phone))));

                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(phone : countrycode.text + phone)));
              },
                backgroundColor: Colors.red[900],
                child: const Icon(Icons.navigate_next_rounded),),
            ],
          )
      ),
    );
  }
}
