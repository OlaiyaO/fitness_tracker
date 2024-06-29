import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../services/location_service.dart';
import '../../utils/kalman_filter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {super.key,
      required this.onStartButtonPressed,
      required this.onStopButtonPressed});

  final VoidCallback onStartButtonPressed;
  final VoidCallback onStopButtonPressed;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LocationService _locationService = LocationService();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.21930, 5.50660),
    zoom: 15,
  );

  // static const LatLng _kTitcombCollege = LatLng(8.21221, 5.52004);
  static const LatLng _kAlayaJunction = LatLng(8.21930, 5.50660);

  LatLng? currentPosition;
  List<LatLng> polylineCoordinates = [];
  bool isDrawing = false;

  StreamSubscription<LocationData>? locationSubscription;
  late KalmanLatLng kalmanLatLng;

  void startDrawing() {
    setState(() {
      isDrawing = true;
    });
    locationSubscription =
        _locationService.getLocationUpdates().listen((LatLng newPosition) {
      if (mounted) {
        LatLng filteredPosition = kalmanLatLng.filter(newPosition);
        setState(() {
          currentPosition = filteredPosition;
          polylineCoordinates.add(filteredPosition);
          if (kDebugMode) {
            print(currentPosition);
          }
        });
      }
    }) as StreamSubscription<LocationData>?;
  }

  void stopDrawing() {
    locationSubscription?.cancel();
    setState(() {
      isDrawing = false;
    });
    widget.onStopButtonPressed();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      const Marker(
          markerId: MarkerId("_startingLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: _kAlayaJunction),
      if (currentPosition != null)
        Marker(
            markerId: const MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: currentPosition!),
    };

    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("location_change"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        polylines: polylines,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          elevation: 12,
          onPressed: isDrawing ? stopDrawing : startDrawing,
          child: Icon(isDrawing ? Icons.stop : Icons.not_started_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
