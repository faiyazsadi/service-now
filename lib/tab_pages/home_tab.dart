import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  // Completer<GoogleMapController> _controllerGooleMap = Completer();
  // GoogleMapController? newGoogleMapController;


  // static const LatLng sourceLocation = LatLng(37.4221, -122.0841);
  // static const LatLng destinationLocation = LatLng(37.4116, -122.0713);

  // List<LatLng> polyLineCoordinates = [];
  // static LocationData? currentLocation;

  // void getCurrentLocation() async {
  //   if(currentLocation != null) return;
  //   Location location = Location();
  //   location.getLocation().then( 
  //     (location) {
  //       currentLocation = location;
  //     },
  //   );
  //   setState(() {
  //   });
  //   sleep(Duration(milliseconds: 200));
    //GoogleMapController googleMapController = await _controllerGooleMap.future;
    //location.onLocationChanged.listen((newLocation) {
      //currentLocation = newLocation;
      //googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLocation.latitude!, newLocation.longitude!),),),);
      //setState(() {});
    //},);
  // }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       key, 
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//     );
//     if(result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng pointLatLng) {
//           polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//       });
//       setState(() {});
//     }
//   }

// @override
//   void initState() {
//     // TODO: implement initState
//     getCurrentLocation();
//     // sleep(const Duration(milliseconds: 200));
//     getPolyPoints();
//     super.initState();
//   }

  StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();
  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;

  final CameraPosition initialLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: const CircleId("car"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }
  
void getCurrentLocation(BuildContext context) async {
    try {

      Uint8List imageData = await getMarker(context);
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
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
        markers: Set.of((marker != null) ? [marker!] : []),
        circles: Set.of((circle != null) ? [circle!] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation(context);
          }),
    );
  }
}