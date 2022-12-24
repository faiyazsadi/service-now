import 'dart:io';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_now/global/global.dart';
import 'package:service_now/tab_pages/earning_tab.dart';
import 'package:service_now/tab_pages/home_tab.dart';
import 'package:service_now/tab_pages/profile_tab.dart';
import 'package:service_now/tab_pages/rating_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  onItemClicked(int index) {
    selectedIndex = index;
    tabController!.index = selectedIndex;
  }
  // 
  var myLatitude, myLongitude;
  var userLatitude, userLongitude;
  var changedScreen = false;

  Future<void> getUserLocation() async {
      DatabaseReference requestRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("request_from");
      final request_from = await requestRef.get();
      DatabaseReference latRef = FirebaseDatabase.instance.ref().child("drivers").child(request_from.value.toString()).child("latitude");
      DatabaseReference lonRef = FirebaseDatabase.instance.ref().child("drivers").child(request_from.value.toString()).child("longitude");
      final lat = await latRef.get();
      final lon = await lonRef.get();
      sleep(Duration(milliseconds: 1000));
      userLatitude = lat.value;
      userLongitude = lon.value;
      print("=====================");
      print(userLatitude);
      print(userLongitude);
      print("=====================");
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
            onPressed: () async { 
              // getUserLocation();
              DatabaseReference mylatRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("latitude");
              DatabaseReference mylonRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("longitude");
              final mylat = await mylatRef.get();
              final mylon = await mylonRef.get().then((mylon) => {
                myLatitude = mylat.value,
                myLongitude = mylon.value
              });

              DatabaseReference requestRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("request_from");
              final request_from = await requestRef.get();

              DatabaseReference latRef = FirebaseDatabase.instance.ref().child("drivers").child(request_from.value.toString()).child("latitude");
              DatabaseReference lonRef = FirebaseDatabase.instance.ref().child("drivers").child(request_from.value.toString()).child("longitude");
              final lat = await latRef.get();
              final lon = await lonRef.get().then((lon) => {
                userLatitude = lat.value,
                userLongitude = lon.value,
                changedScreen = true,
                Navigator.push(context, MaterialPageRoute(builder: (c) => HomeTabPage(
                  myLatitude: myLatitude,
                  myLongitude: myLongitude,
                  userLatitude: userLatitude,
                  userLongitude: userLongitude,
                  changedScreen: changedScreen)))
                  .then((value) => changedScreen = false)
              });
              
            }
            ,
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
        // print("FIRST TIME");
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
    tabController = TabController(length: 4, vsync: this);
    checkForRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(myLatitude: myLatitude, myLongitude: myLongitude, userLatitude: userLatitude, userLongitude: userLongitude, changedScreen: changedScreen),
          EarningsTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: 'Earning'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
