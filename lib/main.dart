import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_now/global/global.dart';
import 'package:service_now/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(
      child: MaterialApp(
        debugShowMaterialGrid: false,
      title: 'Service Now',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(),
      debugShowCheckedModeBanner: false,
    )),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;
  MyApp({this.child});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }
  void getNotification(BuildContext context, var userName) {
    ElegantNotification.info(
      width: 360,
      notificationPosition: NotificationPosition.topCenter,
      toastDuration: const Duration(minutes: 2),
      animation: AnimationType.fromTop,
      title: const Text('Info'),
      description: Text(
        "User $userName is Requesting",
      ),
      action: Row(
        children: [
          ElevatedButton(
            onPressed: () { 
              print("WORKED");
            },
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
            ),
            child: const Text(
                'Accept',
            ),
          ),
          const SizedBox(width: 100),
          ElevatedButton(
            onPressed: () { 
              print("WORKED");
            },
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
            ),
            child: const Text(
                'Decline',
            ),
          ),
        ],
      ), 
      onActionPressed: () {},
      showProgressIndicator: true,
      onDismiss: () {
        print(
          'This print will be displayed when dismissing the popup',
        );
      },
    ).show(context);
  }
  bool firstTime = true;
  void checkForRequests() async {
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("request_time");
    driversRef.onValue.listen((event) async {
      final snapshot = await driversRef.get();
      if(firstTime) {
        firstTime = false;
        print("FIRST TIME?????????");
      } else {
        DatabaseReference requestRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("request_from");
        final request_from = await requestRef.get();
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers").child(request_from.value.toString()).child("name");
        final userName = await userRef.get();
        getNotification(context, userName.value.toString());
        print(userName.value);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkForRequests();
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);
  }
}
