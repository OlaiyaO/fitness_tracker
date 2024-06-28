import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';


double haversineDistance(LatLng start, LatLng end) {
  const earthRadius = 6371e3; // Earth's radius in meters

  final lat1 = start.latitude * pi / 180;
  final lat2 = end.latitude * pi / 180;
  final deltaLat = (end.latitude - start.latitude) * pi / 180;
  final deltaLon = (end.longitude - start.longitude) * pi / 180;

  final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double calculateTotalDistance(List<LatLng> waypoints) {
  double totalDistance = 0.0;

  for (int i = 0; i < waypoints.length - 1; i++) {
    totalDistance += haversineDistance(waypoints[i], waypoints[i + 1]);
  }

  return totalDistance;
}