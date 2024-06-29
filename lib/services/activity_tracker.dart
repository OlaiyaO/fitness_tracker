import 'dart:async';
import 'package:fitness_tracker/services/screenshot_service.dart';
import 'package:fitness_tracker/services/storage_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import '../data/datasources/database_helper.dart';
import 'activity_service.dart';
import 'location_service.dart';

class ActivityTracker {
  final ActivityService _activityService = ActivityService();
  final LocationService _locationService = LocationService();
  final ScreenshotService _screenshotService = ScreenshotService();
  final StorageService _storageService = StorageService();

  StreamSubscription<Activity>? _activitySubscription;
  StreamSubscription<LatLng>? _locationSubscription;

  void startTracking() {
    _activitySubscription = _activityService.activityStream.listen((event) {
      _activityService.handleActivityChange(event.type);
    });

    _locationSubscription = _locationService.getLocationUpdates().listen((location) {
      _activityService.handleGpsUpdate(location);
    });
  }

  Future<void> stopTracking() async {
    await _activitySubscription?.cancel();
    await _locationSubscription?.cancel();

    final session = _activityService.createActivitySession();
    await DatabaseHelper().insertActivitySession(session);
    await _storageService.saveSessionData(session as Map<String, dynamic>);

    final screenshot = await _screenshotService.captureMapImage(_activityService.waypoints);
    if (screenshot != null) {
      await _storageService.uploadImage(screenshot, session.startTime.toString());
    }
  }
}
