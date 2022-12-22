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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  onItemClicked(int index) {
    selectedIndex = index;
    tabController!.index = selectedIndex;
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
    tabController = TabController(length: 4, vsync: this);
    checkForRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
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
