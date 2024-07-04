import 'dart:async';

import 'package:fitness_tracker/utils/image_utils.dart';
import 'package:fitness_tracker/utils/total_distance_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../services/location_service.dart';
import '../../services/map_image_capture_save.dart';
import '../../services/session_manager.dart';
import '../../utils/kalman_filter.dart';
import '../../utils/summay_page_navigation_utils.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.onStartButtonPressed,
    required this.onStopButtonPressed,
  });

  final VoidCallback onStartButtonPressed;
  final VoidCallback onStopButtonPressed;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LocationService _locationService = LocationService();
  final ScreenshotUtils _screenshotUtils = ScreenshotUtils();
  final DistanceStepCalculator _distanceStepCalculator =
      DistanceStepCalculator();

  Uint8List? imageBytes;
  String? localPath;
  String? imageUrl;

  LatLng? currentPosition;
  List<LatLng> polylineCoordinates = [];
  bool isDrawing = false;
  bool isLoading = true;

  String? sessionId;
  StreamSubscription<LocationData>? locationSubscription;
  KalmanLatLng? kalmanLatLng;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? date;

  @override
  void initState() {
    super.initState();
    kalmanLatLng = KalmanLatLng();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _locationService.checkServiceAndPermission();

    LocationData? locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
        isLoading = false;
      });

      _startLocationUpdates();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    locationSubscription = _locationService
        .getLocationUpdates()
        .listen((LocationData locationData) {
      if (kalmanLatLng != null && mounted) {
        LatLng newPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
        LatLng filteredPosition = kalmanLatLng!.filter(newPosition);
        setState(() {
          currentPosition = filteredPosition;
          if (isDrawing) {
            polylineCoordinates.add(filteredPosition);
          }
          if (kDebugMode) {
            print(currentPosition);
          }
        });
      }
    });
  }

  void _createSession() async {
    sessionId = await SessionManager.createSession(
      date: DateTime.now(),
      startTime: TimeOfDay.now(),
    );
    startTime = TimeOfDay.now();
    date = DateTime.now();
  }

  void _updateSession(
      double distance, int steps, String? localPath, String? imageUrl) async {
    if (sessionId != null) {
      await SessionManager.updateSession(
        localPath: localPath,
        imageUrl: imageUrl,
        sessionId: sessionId!,
        distance: distance,
        steps: steps,
        startTime: startTime!,
        endTime: TimeOfDay.now(),
      );
      endTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("location_change"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };

    void startDrawing() {
      if (currentPosition != null) {
        setState(() {
          isDrawing = true;
          polylineCoordinates = [currentPosition!];
        });
        widget.onStartButtonPressed();
        _createSession();
      }
    }

    Future<void> stopDrawing() async {
      setState(() {
        isDrawing = false;
      });
      Map<String, String?> imagePaths =
          await ImageUtils.takeSnapshotAndSave(_controller, _screenshotUtils);
      localPath = imagePaths['localPath'];
      imageUrl = imagePaths['imageUrl'];

      print('$imagePaths');

      widget.onStopButtonPressed();
      // Here you would calculate the distance and steps to update the session
      double distance =
          _distanceStepCalculator.calculateDistance(polylineCoordinates);
      int steps =
          _distanceStepCalculator.calculateTotalSteps(polylineCoordinates);

      _updateSession(distance, steps, localPath!, imageUrl);
      if (localPath != null || imageUrl != null) {
        navigateToSummaryScreen(context, localPath ?? '', imageUrl ?? '',
            startTime!, endTime!, date!, distance, steps);
      }
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition ?? const LatLng(0, 0),
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  polylines: polylines,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: FloatingActionButton(
                    elevation: 20,
                    onPressed: isDrawing ? stopDrawing : startDrawing,
                    child: Icon(isDrawing ? Icons.stop : Icons.play_arrow),
                  ),
                ),
              ],
            ),
    );
  }
}
