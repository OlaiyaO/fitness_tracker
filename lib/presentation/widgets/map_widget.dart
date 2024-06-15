import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../repositories/location_repository.dart';

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
  static const LatLng _kAlayaJunction = LatLng(8.21930, 5.50660);
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocationUpdates((LatLng newPosition) {
      setState(() {
        currentPosition = newPosition;
        if (kDebugMode) {
          print(currentPosition);
        }
      });
    });
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
            position:
                currentPosition == null ? _kTitcombCollege : currentPosition!),
      },
    );
  }
}
