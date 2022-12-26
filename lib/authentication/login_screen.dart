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

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();
//
//   validateForm() {
//     if (!emailTextEditingController.text.contains('@')) {
//       Fluttertoast.showToast(msg: 'Email is not valid.');
//     } else if (passwordTextEditingController.text.isEmpty) {
//       Fluttertoast.showToast(msg: 'Password is required.');
//     } else {
//       loginDriver();
//       DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("isBusy");
//       driverRef.set(false);
//     }
//   }
//
//   loginDriver() async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return ProgressDialog(
//             message: "Processing. Please Wait...",
//           );
//         });
//     final User? firebaseUser = (await fAuth
//             .signInWithEmailAndPassword(
//       email: emailTextEditingController.text.trim(),
//       password: passwordTextEditingController.text.trim(),
//     )
//             .catchError((msg) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: 'Error: ' + msg.toString());
//     }))
//         .user;
//
//     if (firebaseUser != null) {
//       currentFirebaseuser = firebaseUser;
//       Fluttertoast.showToast(msg: 'Account has been created.');
//       Navigator.push(
//           context, MaterialPageRoute(builder: (c) => const MainScreen()));
//     } else {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: 'Error occured while logging in.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Image.asset('images/service_now_logo.jpeg'),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 'Login as a Driver',
//                 style: TextStyle(
//                     fontSize: 26,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: emailTextEditingController,
//                 keyboardType: TextInputType.emailAddress,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                 ),
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Email',
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: passwordTextEditingController,
//                 keyboardType: TextInputType.text,
//                 obscureText: true,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                 ),
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Password',
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   validateForm();
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreenAccent),
//                 child: const Text(
//                   'Login',
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               TextButton(
//                 child: const Text(
//                   'Don\'t have an account? Register Here.',
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SignUpScreen(phone: "+8801881445979"),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//This is the class for providing phone number for OTP***********************************


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
              SizedBox(height: 30.0,),
              Text(
                "Service Now",
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Provider Apps",
                style: TextStyle(
                  fontSize: 30.0,
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
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyOtp(phone : countrycode.text + phone)));
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(phone : countrycode.text + phone)));
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
                // Navigator.push(
                //     context, MaterialPageRoute(builder: ((context) => MyOtp(text: phone))));

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(phone : countrycode.text + phone)));
              },
                backgroundColor: Colors.red[900],
                child: const Icon(Icons.navigate_next_rounded),),
            ],
          )
      ),
    );
  }
}

