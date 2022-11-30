import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:location/location.dart';
import 'package:service_now/global/map_key.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGooleMap = Completer();
  GoogleMapController? newGoogleMapController;


  static const LatLng sourceLocation = LatLng(37.4221, -122.0841);
  static const LatLng destinationLocation = LatLng(37.4116, -122.0713);

  List<LatLng> polyLineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then( 
      (location) {
        currentLocation = location;
      },
    );
    //GoogleMapController googleMapController = await _controllerGooleMap.future;
    //location.onLocationChanged.listen((newLocation) {
      //currentLocation = newLocation;
      //googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLocation.latitude!, newLocation.longitude!),),),);
      //setState(() {});
    //},);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if(result.points.isNotEmpty) {
      result.points.forEach((PointLatLng pointLatLng) {
          polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      setState(() {});
    }
  }

@override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    sleep(const Duration(milliseconds: 200));
    getPolyPoints();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        currentLocation == null 
        ?  const Center(child: Text("Loading..."),)
        : GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.5,
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId("route"),
              points: polyLineCoordinates,
              color: Colors.blueAccent,
              width: 6,
            )
          },
          markers: {
            Marker(markerId: const MarkerId("currentLocation"), position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),),
          },
        ),
      ],
    );
  }
}
