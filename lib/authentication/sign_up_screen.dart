import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:service_now/authentication/car_info_screen.dart';
import 'package:service_now/global/global.dart';
import 'package:service_now/main_screen/main_screen.dart';
import 'package:service_now/widgets/progress_dialog.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';


import 'login_screen.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';



class SignUpScreen extends StatefulWidget {
  String phone;
  SignUpScreen({required this.phone});

  //const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState(phone);
}

class _SignUpScreenState extends State<SignUpScreen> {
  String phone;
  _SignUpScreenState(this.phone);
  final formKey = GlobalKey<FormState>(); //key for form
  String name="";
  String imageUrl="";
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  List<String> carTypesList = ['Car Servicing', 'Fuel Service', 'Ambulance Service'];


  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Choose media to select!',
              style: TextStyle(
                fontSize: 23,
                fontFamily: "Ubuntu",
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  SizedBox(width: 25,),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () async {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 15,
                      primary: Colors.white,
                      shadowColor: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image,
                          color: Colors.red.shade900,
                          size: 20,
                        ),
                        SizedBox(width: 15,),
                        Text('Gallery',style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontSize: 20,
                          color: Colors.red.shade900,
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    style: ElevatedButton.styleFrom(
                      elevation: 15,
                      primary: Colors.white,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera,
                          color: Colors.red.shade900,),
                        SizedBox(width: 15,),
                        Text('Camera', style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontSize: 20,
                          color: Colors.red.shade900,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? selectedCarType;

  //ProductTypeEnum? _serviceTypeEnum;


  void initState(){
    super.initState();
    phoneTextEditingController.text = phone;
  }

  // validateForm() {
  //   if (nameTextEditingController.text.length < 3) {
  //     Fluttertoast.showToast(msg: "Name must be at least 3 characters long.");
  //   } else if (!emailTextEditingController.text.contains('@')) {
  //     Fluttertoast.showToast(msg: 'Email is not valid.');
  //   } else if (phoneTextEditingController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Phone number is required.');
  //   } else if (passwordTextEditingController.text.length < 6) {
  //     Fluttertoast.showToast(msg: 'Password must be at least 6 characters.');
  //   } else {
  //     saveDriverInfo();
  //   }
  // }

  saveDriverInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Processing. Please Wait...",
          );
        });
    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: phoneTextEditingController.text.trim(),
    ).catchError((msg) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext contest){
        return AlertDialog(
          title: Text("Opps!!",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.red.shade900,
              fontFamily: "FredokaOne",
            ),),
          content: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 20.0),
            child: Text('This email already exists or incorrect email format.',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
                fontFamily: "Ubuntu",
              ),
            ),
          ),
        );
      });
      // Fluttertoast.showToast(msg: 'Error: ' + msg.toString());
    })).user;

    // if(imageUrl.isEmpty){
    //   print("something went wrong");
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PLease upload an image")));
    //   return;
    // }
    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "image": imageUrl,
        "isActive": true,
        "isBusy": false,
        "latitude": 123,
        "longitude": 123,
        "type": selectedCarType,
        "sum": 0,
        "rating": 0,
        "ServiceCountr": 0,
      };
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);
      currentFirebaseuser = firebaseUser;

      Fluttertoast.showToast(msg: 'Account has been created.');
      showDialog(context: context, builder: (BuildContext contest){
        return AlertDialog(
          title: Text("Congratulation!!",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.red.shade900,
              fontFamily: "FredokaOne",
            ),),
          content: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 20.0),
            child: Text("Account has been created successfully",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
                fontFamily: "Ubuntu",
              ),
            ),
          ),
        );
      });
      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      });


    } else {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext contest){
        return AlertDialog(
          title: Text("Opps!!",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.red.shade900,
              fontFamily: "FredokaOne",
            ),),
          content: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 20.0),
            child: Text("Account could not be created",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
                fontFamily: "Ubuntu",
              ),
            ),
          ),
        );
      });

      // Fluttertoast.showToast(msg: 'Account could not be created.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFffffff),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 90,),
                  Text("Here to get",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.red.shade900,
                      fontFamily: "FredokaOne",
                    ),
                  ),
                  Text("Welcome !!",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.red.shade900,
                      fontFamily: "FredokaOne",
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black, spreadRadius: 1)],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.red.shade900,
                              //backgroundImage: AssetImage('images/service_now_logo.jpeg'),
                              child: Container(
                                  child: image != null ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        //to show image, you type like this.
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 300,
                                      ),
                                    ),
                                  )
                                      : Icon(Icons.person,
                                    size: 60,
                                    color: Colors.white,)
                              ),
                              radius: 56.0,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade900,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 0, color: Colors.black, spreadRadius: 0)],
                              ),
                              child: IconButton(
                                onPressed: () async{
                                  myAlert();
                                },
                                icon: Icon(Icons.add_a_photo_rounded,
                                  color: Colors.white,
                                  size: 20,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: nameTextEditingController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_rounded),
                      labelText: "Enter provider name",
                      focusColor: Colors.red.shade900,
                    ),
                    validator: (value){
                      if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)){
                        return "Enter Correct Name (Only A-Z or a-z are allowed)";
                      }
                      else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    enabled: false,
                    //enableInteractiveSelection: false, // will disable paste operation
                    controller: phoneTextEditingController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone_android_rounded),
                      labelText: "Enter your Phone",
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_rounded),
                      labelText: "Enter Your Email",
                    ),
                    validator: (value){
                      if(value!.isEmpty || RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2, 4}').hasMatch(value!)){
                        return "Enter Correct Email";
                      }
                      else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  Center(
                   child: DropdownButton(
                          hint: const Text(
                            'Choose Service Type',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black54,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                          value: selectedCarType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCarType = newValue.toString();
                              print(selectedCarType);
                            });
                          },
                          items: carTypesList.map((car) {
                            return DropdownMenuItem(
                              child: Text(car,
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontFamily: "Ubuntu",
                                  fontSize: 23,
                                ),
                              ),
                              value: car,
                            );
                          }).toList(),
                        ),),
                  SizedBox(height: 50,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 5,),
                      Text("Sign Up Now", style: TextStyle(
                        fontSize: 28,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Ubuntu",
                      ),),
                      FloatingActionButton(
                        onPressed: () async{
                          if(formKey.currentState!.validate()){
                            if(image==null) return;

                            String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();

                            //Get a reference to storage root
                            Reference referenceRoot = FirebaseStorage.instance.ref();
                            Reference referenceDirImages = referenceRoot.child('images');

                            //Create a reference for the image to be stored
                            Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                            //Store the file
                            try{
                              await referenceImageToUpload.putFile(File(image!.path)).then((p0) async {
                                imageUrl = await referenceImageToUpload.getDownloadURL();
                                print("The imageurl is: "+imageUrl.toString());
                              });
                              //imageUrl = await referenceImageToUpload.getDownloadURL();
                            }catch(error){
                              //Do something for handling error
                              print("Some error:    " + error.toString());
                            }
                            print("*****************************************d65f46s4fd6gdg*************");
                            saveDriverInfo();
                          }
                        },
                        child: const Icon(Icons.navigate_next_rounded),
                        backgroundColor: Colors.red[900],
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //   Scaffold(
    //   backgroundColor: Colors.black,
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         children: [
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(20.0),
    //             child: Image.asset('images/service_now_logo.jpeg'),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           const Text(
    //             'Register as a Driver',
    //             style: TextStyle(
    //                 fontSize: 26,
    //                 color: Colors.grey,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //           TextField(
    //             controller: nameTextEditingController,
    //             style: const TextStyle(
    //               color: Colors.grey,
    //             ),
    //             decoration: const InputDecoration(
    //               labelText: 'Name',
    //               hintText: 'Name',
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               hintStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 10,
    //               ),
    //               labelStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 15,
    //               ),
    //             ),
    //           ),
    //           TextField(
    //             controller: emailTextEditingController,
    //             keyboardType: TextInputType.emailAddress,
    //             style: const TextStyle(
    //               color: Colors.grey,
    //             ),
    //             decoration: const InputDecoration(
    //               labelText: 'Email',
    //               hintText: 'Email',
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               hintStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 10,
    //               ),
    //               labelStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 15,
    //               ),
    //             ),
    //           ),
    //           TextField(
    //             controller: phoneTextEditingController,
    //             keyboardType: TextInputType.phone,
    //             style: const TextStyle(
    //               color: Colors.grey,
    //             ),
    //             decoration: const InputDecoration(
    //               labelText: 'Phone',
    //               hintText: 'Phone',
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               hintStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 10,
    //               ),
    //               labelStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 15,
    //               ),
    //             ),
    //           ),
    //           TextField(
    //             controller: passwordTextEditingController,
    //             keyboardType: TextInputType.text,
    //             obscureText: true,
    //             style: const TextStyle(
    //               color: Colors.grey,
    //             ),
    //             decoration: const InputDecoration(
    //               labelText: 'Password',
    //               hintText: 'Password',
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.grey),
    //               ),
    //               hintStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 10,
    //               ),
    //               labelStyle: TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 15,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           ElevatedButton(
    //             onPressed: () {
    //               //todo
    //               validateForm();
    //               // Navigator.push(
    //               //   context,
    //               //   MaterialPageRoute(
    //               //     builder: (context) => CarInfoScreen(),
    //               //   ),
    //               // );
    //             },
    //             style: ElevatedButton.styleFrom(
    //                 backgroundColor: Colors.lightGreenAccent),
    //             child: const Text(
    //               'Create Account',
    //               style: TextStyle(
    //                 color: Colors.black54,
    //                 fontSize: 18,
    //               ),
    //             ),
    //           ),
    //           TextButton(
    //             child: const Text(
    //               'Already have an account? Login Here.',
    //               style: TextStyle(
    //                 color: Colors.grey,
    //               ),
    //             ),
    //             onPressed: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => LoginScreen(),
    //                 ),
    //               );
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
