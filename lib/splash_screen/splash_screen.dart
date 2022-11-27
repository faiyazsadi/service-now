import 'dart:async';

import 'package:flutter/material.dart';
import 'package:service_now/authentication/login_screen.dart';
import 'package:service_now/authentication/sign_up_screen.dart';
import 'package:service_now/global/global.dart';
import 'package:service_now/main_screen/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      // send user to main screen
      if (await fAuth.currentUser != null) {
        currentFirebaseuser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => MainScreen())));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/service_now_logo.jpeg'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Service Now',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
