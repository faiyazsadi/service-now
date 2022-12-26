import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:service_now/global/global.dart';

import '../splash_screen/splash_screen.dart';


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
        color: Colors.blue,
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

  static CameraPosition initialLocation = const CameraPosition(
    target: LatLng(22.899185265097515, 89.5051113558963),
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

      setState(() {
        initialLocation = CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 18.00
        );
        _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(location.latitude!, location.longitude!),
            tilt: 0,
            zoom: 18.00)));
      });
      print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
      print(currentFirebaseuser!.uid);
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
        DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
        final snapshot = await driversRef.get();
        final drivers = snapshot.value as Map<dynamic, dynamic>;
        drivers.forEach((key, value) async { 
          if(value["isActive"] == true) {
            var uid = value["id"];
            if(value["id"] != currentFirebaseuser!.uid) {
              Uint8List imageData = await getMarker(context);
              var latitude = value["latitude"];
              var longitude = value["longitude"];
              LatLng latLng = LatLng(latitude, longitude);
              setState(() {

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

  void fetchData() async{
    DatabaseReference  driversRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid);
    final user = await (driversRef.child("name")).get();
    final imageUrl = await (driversRef.child("image")).get();

    setState(() {
      user_name = user!.value.toString();
      urlImage = imageUrl!.value.toString();

      //print("after setting: ${urlImage}");
    });
  }

  String urlImage = "https://firebasestorage.googleapis.com/v0/b/emergency-service-d0d19.appspot.com/o/images%2Floading.png?alt=media&token=f1bd6f13-b2c8-4f88-b14a-b2581d01ee84";
  String user_name = "";

  String? usr_name, user_phone_no, user_image;

  void getUserInfo() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("request_from");
    final userid = await userRef.get();
    DatabaseReference uRef = FirebaseDatabase.instance.ref().child("users").child(userid.value.toString());
    final user_name_snap = await uRef.child("name").get();
    final user_phone_no_snap = await uRef.child("phone").get();
    final user_image_snap = await uRef.child("image").get();
    usr_name = user_name_snap.value.toString();
    user_phone_no = user_phone_no_snap.toString();
    user_image = user_image_snap.value.toString();
  }

@override
  initState() {
    super.initState();
    fetchData();
    getCurrentLocation(context);
    getActiveUsers(context);

    // if(widget.changedScreen == true) {
    //   PointLatLng myLocation = PointLatLng(widget.myLatitude, widget.myLongitude);
    //   PointLatLng userLocation = PointLatLng(widget.userLatitude, widget.userLongitude);
    //   getUserInfo();
    //   makeLines(myLocation, userLocation);
    // }
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
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseuser!.uid).child("isBusy");
    final snapshot = ref.get().asStream();
    return  Scaffold(
      appBar: AppBar(

        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('This is a snackbar')));

        leading: Builder(
          builder: (BuildContext context) {
            return CircleAvatar(
                backgroundColor: Colors.red.shade900,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.3, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: urlImage != null ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: Image.network(urlImage,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Icon(Icons.person,
                      size: 15,
                      color: Colors.black,)
                ),
                radius: 5.0,
              );
          },
        ),

        title: Text(user_name,
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Ubuntu",
          ),),
        centerTitle: false,
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
        elevation: 25,
        toolbarHeight: 60,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showDialog(context: context, builder: (BuildContext contest){return AlertDialog(
                title: Text("Warning !!",
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.red.shade900,
                    fontFamily: "FredokaOne",
                  ),),
                content: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0, top: 10.0),
                  child: Text('Are you sure to sign out?',
                    style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.black45,
                      fontFamily: "Ubuntu",
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
                        driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
                        fAuth.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const MySplashScreen())));
                      },
                      child: Text(
                        "YES",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red.shade900,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  TextButton(onPressed:(){
                    Navigator.of(context).pop();
                  },
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red.shade900,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  SizedBox(width: 0,)
                ],
              );});
            },
            icon: Icon(Icons.logout_rounded,
              size: 30,),
            // onPressed: () {
            //   DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
            //   driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
            //   fAuth.signOut();
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: ((context) => const MySplashScreen())));
            // },

          ),
          SizedBox(width: 15,),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
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
      
// <<<<<<< HEAD
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           notifyActiveDrivers();
      //         },
      //         child: const Text('Request Help'),
      //         style: ElevatedButton.styleFrom(
      //             // icon:
      //             backgroundColor: Colors.deepPurple[700],
      //       ),
      //       ),
      //       SizedBox(width: 200),
      //       FloatingActionButton(
      //         child: const Icon(Icons.location_searching),
      //         onPressed: () {
      //           getCurrentLocation(context);
      //           getActiveUsers(context);
      //         }
      //       ),
      //     ],
      //   ),
      // )
// =======
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            StreamBuilder(
              stream: snapshot,
              builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                if(snapshot.hasData) {
                  currDriverStatus = snapshot.data!.value.toString();
                  print(currDriverStatus);
                  if(prevDriverStatus == "true" && currDriverStatus == "false") {
                    polylines.clear();
                    polylineCoordinates.clear();
                  }
                  prevDriverStatus = currDriverStatus;
                }
                return const Text("");
              }
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     notifyActiveDrivers();
            //   },
            //   child: const Text('Request Help'),
            //   style: ElevatedButton.styleFrom(
            //       // icon:
            //       backgroundColor: Colors.deepPurple[700],
            // ),
            // ),

            SizedBox(width: 200),
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: FloatingActionButton(
                backgroundColor: Colors.red.shade900,
                child: const Icon(Icons.location_on_rounded),
                onPressed: () {
                  //print("Mahim");
                  getCurrentLocation(context);
                  getActiveUsers(context);
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}