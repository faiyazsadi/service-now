// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:service_now/global/global.dart';


class HomeTabPage extends StatefulWidget {
  final myLatitude, myLongitude, userLatitude, userLongitude;
  final bool changedScreen;
  const HomeTabPage({super.key, required this.myLatitude, required this.myLongitude, required this.userLatitude, required this.userLongitude, required this.changedScreen});
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  StreamSubscription? _locationSubscription, _locationSubscriptionOthers;
  final Location _locationTracker = Location();
  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;
  Map<dynamic, Marker> markers = <dynamic, Marker>{};
  Map<dynamic, Circle> circles = <dynamic, Circle>{};

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates
    );
    polylines[id] = polyline;
    setState((){});
 }
 void makeLines(PointLatLng myLocation, PointLatLng userLocation) async {
     await polylinePoints
          .getRouteBetweenCoordinates(
            // 'GOOGLE MAP API KEY'
            // PointLatLng(6.2514, 80.7642), //Starting LATLANG
            // PointLatLng(6.9271, 79.8612), //End LATLANG
             'AIzaSyB3UWDair3TJS0xnJviTeo3wasW1TUvLdI',
              myLocation,
              userLocation,
              travelMode: TravelMode.driving,
    ).then((value) {
        value.points.forEach((PointLatLng point) {
           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
       });
   }).then((value) {
      addPolyLine();
   });
 }

  final CameraPosition initialLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData, var uid) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      marker = Marker(
          markerId: MarkerId(uid),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

      circle = Circle(
          circleId: CircleId(uid),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));

      markers[uid] = marker!;
      circles[uid] = circle!;
    });
  }

void getCurrentLocation(BuildContext context) async {
    try {
      Uint8List imageData = await getMarker(context);
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData, currentFirebaseuser!.uid);
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(currentFirebaseuser!.uid).update({"latitude": location.latitude, "longitude": location.longitude});
      
      DatabaseReference userConnection = FirebaseDatabase.instance.ref().child("drivers/${currentFirebaseuser!.uid}/isActive");
      userConnection.onDisconnect().set(false);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          driversRef.child(currentFirebaseuser!.uid).update({"latitude": newLocalData.latitude, "longitude": newLocalData.longitude});
          DatabaseReference userConnection = FirebaseDatabase.instance.ref().child("drivers/${currentFirebaseuser!.uid}/isActive");
          userConnection.onDisconnect().set(false);
          _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData, currentFirebaseuser!.uid);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

void getActiveUsers(BuildContext context) async {
  try {
    if (_locationSubscriptionOthers != null) {
      _locationSubscriptionOthers!.cancel();
    }
    _locationSubscriptionOthers = _locationTracker.onLocationChanged.listen((newLocalData) async {
      if(_controller != null) {
        DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
        final snapshot = await driversRef.get();
        final drivers = snapshot.value as Map<dynamic, dynamic>;
        drivers.forEach((key, value) async { 
          if(value["isActive"] == true) {
            var uid = value["id"];
            if(value["id"] != currentFirebaseuser!.uid) { 
              // print("===============================");
              // print("uid: " + uid);
              // print("===============================");
              Uint8List imageData = await getMarker(context);
              var latitude = value["latitude"];
              var longitude = value["longitude"];
              LatLng latLng = LatLng(latitude, longitude);
              setState(() {
                // print(uid);
                // print("==========================");
                var m = Marker(
                    markerId: MarkerId(uid),
                    position: latLng,
                    // rotation: newLocalData.heading!,
                    draggable: false,
                    zIndex: 2,
                    flat: true,
                    anchor: const Offset(0.5, 0.5),
                    icon: BitmapDescriptor.fromBytes(imageData));
                var c = Circle(
                    circleId: CircleId(uid),
                    // radius: latLng.accuracy,
                    zIndex: 1,
                    strokeColor: Colors.blue,
                    center: latLng,
                    fillColor: Colors.blue.withAlpha(70));

                markers[uid] = m;
                circles[uid] = c;
              });
            }
          }
        });
      }
    });
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      debugPrint("Permission Denied");
    }
  }
  
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
  @override 
  initState() {
    super.initState();
    getCurrentLocation(context);
    getActiveUsers(context);

    // print("===================================");
    // print(widget.latitude);
    // print(widget.longitude);
    // print(widget.changedScreen);
    // print("===================================");

    // print("###############################");
    // print(myLatitude);
    // print(myLongitude);
    // print("###############################");

    if(widget.changedScreen == true) {
      PointLatLng myLocation = PointLatLng(widget.myLatitude, widget.myLongitude);
      PointLatLng userLocation = PointLatLng(widget.userLatitude, widget.userLongitude);
      makeLines(myLocation, userLocation);
      
      // PointLatLng userLocation = PointLatLng(22.8988367, 89.50415);
      // PointLatLng myLocation = PointLatLng(22.8988367, 89.50415);
      
    }
    
  }
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    if (_locationSubscriptionOthers != null) {
      _locationSubscriptionOthers!.cancel();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        // markers: Set.of((marker != null) ? [marker!] : []),
        // circles: Set.of((circle != null) ? [circle!] : []),

        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                notifyActiveDrivers();
              },
              child: const Text('Request Help'),
              style: ElevatedButton.styleFrom(
                  // icon: 
                  backgroundColor: Colors.deepPurple[700],
            ),
            ),
            SizedBox(width: 200),
            FloatingActionButton(
              child: const Icon(Icons.location_searching),
              onPressed: () {
                getCurrentLocation(context);
                getActiveUsers(context);
              }
            ),
          ],
        ),
      )
    );
  }
}