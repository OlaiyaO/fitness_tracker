import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.2193, 5.5066),
    zoom: 16,
  );

  static const LatLng _kTitcombCollege = LatLng(8.21221, 5.52004);
  static const LatLng _kAlayaJunction = LatLng(.21930, 5.50660);
  LatLng? currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {
        const Marker(
            markerId: MarkerId("_startingLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _kAlayaJunction),
        Marker(
            markerId: const MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: currentPosition == null ? _kTitcombCollege : currentPosition!),
      },
    );
  }

  Future<void> getLocationUpdates() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData locationData) {
      if(locationData.longitude != null && locationData.latitude != null) {
        setState((){
          currentPosition = LatLng(locationData.longitude!, locationData.longitude!);
          if (kDebugMode) {
            print(currentPosition);
          }
        });
      }
    });
  }
}

