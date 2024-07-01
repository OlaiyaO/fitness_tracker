import 'dart:async';

import 'package:fitness_tracker/services/pedometer_service.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/activity_session_model.dart';
import '../utils/haversine_distance_calculator.dart';
import '../utils/kalman_filter.dart';

class ActivityService {
  DateTime startTime = DateTime.now();
  DateTime lastActivityChangeTime = DateTime.now();
  ActivityType? currentActivity;

  double walkingDistance = 0.0;
  double runningDistance = 0.0;
  double cyclingDistance = 0.0;

  Duration walkingTime = Duration.zero;
  Duration runningTime = Duration.zero;
  Duration cyclingTime = Duration.zero;

  int steps = 0;

  final List<LatLng> waypoints = [];
  final PedometerService pedometerService = PedometerService();
  final KalmanLatLng kalmanFilter = KalmanLatLng();

  void startPedometer() {
    pedometerService.initPedometer();
    pedometerService.stepsStream.listen((stepCount) {
      steps = stepCount;
    });
  }

  void stopPedometer() {
    pedometerService.dispose();
  }

  final Stream<Activity> activityStream =
      FlutterActivityRecognition.instance.activityStream;

  void handleGpsUpdate(LatLng newLocation) {
    LatLng filteredLocation = kalmanFilter.filter(newLocation);
    waypoints.add(filteredLocation);
  }

  void handleActivityChange(ActivityType newActivity) {
    DateTime now = DateTime.now();
    if (currentActivity != null && waypoints.isNotEmpty) {
      double activityDistance = calculateTotalDistance(waypoints);
      Duration activityDuration = now.difference(lastActivityChangeTime);
      _updateActivityStats(
          currentActivity!, activityDistance, activityDuration);
      waypoints.clear();
    }
    currentActivity = newActivity;
    lastActivityChangeTime = now;
  }

  void _updateActivityStats(
      ActivityType type, double distance, Duration duration) {
    if (type == ActivityType.WALKING) {
      walkingTime += duration;
      walkingDistance += distance;
    } else if (type == ActivityType.RUNNING) {
      runningTime += duration;
      runningDistance += distance;
    } else if (type == ActivityType.ON_BICYCLE) {
      cyclingTime += duration;
      cyclingDistance += distance;
    }
  }

  ActivitySession createActivitySession() {
    return ActivitySession(
      walkingDistance: walkingDistance,
      runningDistance: runningDistance,
      cyclingDistance: cyclingDistance,
      walkingTime: walkingTime,
      runningTime: runningTime,
      cyclingTime: cyclingTime,
      steps: steps,
      startTime: startTime,
      endTime: DateTime.now(),
    );
  }
}
