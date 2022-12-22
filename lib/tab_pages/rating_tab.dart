import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_now/global/global.dart';

class RatingTabPage extends StatefulWidget {
  const RatingTabPage({super.key});

  @override
  State<RatingTabPage> createState() => _RatingTabPageState();
}

void notifyActiveDrivers() async {
  DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
  final snapshot = await driversRef.get();
  final drivers = snapshot.value as Map<dynamic, dynamic>;
  drivers.forEach((key, value) async { 
    if(value["id"] != currentFirebaseuser!.uid && value["isActive"] == true) {
      print(value["id"]);
      DateTime time = DateTime.now();
      await driversRef.child(value["id"]).update({"request_from": currentFirebaseuser!.uid});
      await driversRef.child(value["id"]).update({"request_time": time.toString()});
    }
  });
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text('Rating'),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating Tab"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              notifyActiveDrivers();
            },
            child: const Text('Request Aid'),
          ),
      ),
    );
  }
}
