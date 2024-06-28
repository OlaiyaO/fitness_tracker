import 'dart:async';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/haversine_distance_calculator.dart';
import '../utils/kalman_filter.dart';
import 'location_service.dart';

class ActivityTracker {
  DateTime lastActivityChangeTime = DateTime.now();
  ActivityType? currentActivity;

  double walkingDistance = 0.0;
  double runningDistance = 0.0;
  double cyclingDistance = 0.0;

  Duration walkingTime = Duration.zero;
  Duration runningTime = Duration.zero;
  Duration cyclingTime = Duration.zero;

  List<LatLng> waypoints = [];
  KalmanLatLng kalmanFilter = KalmanLatLng();

  StreamSubscription<LatLng>? locationSubscription;
  StreamSubscription<Activity>? activityStreamSubscription;

  void startTracking() async {
    // Initialize activity recognition
    activityStreamSubscription = FlutterActivityRecognition
        .instance.activityStream
        .listen((Activity event) {
      handleActivityChange(event.type);
    });

    // Initialize location updates
    locationSubscription = getLocationUpdates().listen((LatLng location) {
      handleGpsUpdate(location);
    });
  }

  void stopTracking() {
    locationSubscription?.cancel();
    activityStreamSubscription?.cancel();
  }

  void handleGpsUpdate(LatLng newLocation) {
    LatLng filteredLocation = kalmanFilter.filter(newLocation);
    waypoints.add(filteredLocation);
  }

  void handleActivityChange(ActivityType newActivity) {
    DateTime now = DateTime.now();

    if (currentActivity != null && waypoints.isNotEmpty) {
      double activityDistance = calculateTotalDistance(waypoints);
      Duration activityDuration = now.difference(lastActivityChangeTime);

      // Update cumulative times and distances based on the current activity
      if (currentActivity == ActivityType.WALKING) {
        walkingTime += activityDuration;
        walkingDistance += activityDistance;
      } else if (currentActivity == ActivityType.RUNNING) {
        runningTime += activityDuration;
        runningDistance += activityDistance;
      } else if (currentActivity == ActivityType.ON_BICYCLE) {
        cyclingTime += activityDuration;
        cyclingDistance += activityDistance;
      }

      // Reset waypoints for the new activity
      waypoints.clear();
    }

    // Update current activity and time
    currentActivity = newActivity;
    lastActivityChangeTime = now;
  }

  void logSessionData() {
    // Log or store session details including start/end times, distances, etc.
    print(
        'Walking Distance: $walkingDistance meters, Time: ${walkingTime.inMinutes} minutes');
    print(
        'Running Distance: $runningDistance meters, Time: ${runningTime.inMinutes} minutes');
    print(
        'Cycling Distance: $cyclingDistance meters, Time: ${cyclingTime.inMinutes} minutes');
  }
}
