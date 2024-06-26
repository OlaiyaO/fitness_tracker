import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../services/location_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, required this.onStartButtonPressed, required this.onStopButtonPressed});

  final VoidCallback onStartButtonPressed;
  final VoidCallback onStopButtonPressed;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.2193, 5.5066),
    zoom: 15,
  );

  static const LatLng _kTitcombCollege = LatLng(8.21221, 5.52004);
  static const LatLng _kAlayaJunction = LatLng(8.21930, 5.50660);

  LatLng? currentPosition;
  List<LatLng> polylineCoordinates = [];
  bool isDrawing = false;

  StreamSubscription<LocationData>? locationSubscription;

  void startDrawing() {
    setState(() {
      isDrawing = true;
    });
    locationSubscription = getLocationUpdates().listen((LatLng newPosition) {
      if (mounted) {
        setState(() {
          currentPosition = newPosition;
          polylineCoordinates.add(newPosition);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isDrawing ? stopDrawing : startDrawing,
        label: Text(isDrawing ? 'Stop' : 'Start'),
        icon: Icon(isDrawing ? Icons.stop : Icons.not_started_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
