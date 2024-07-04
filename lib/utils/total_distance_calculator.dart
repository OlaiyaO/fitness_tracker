import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'haversine_distance_calculator.dart';

class DistanceStepCalculator {

  double calculateDistance(List<LatLng> coordinates) {
    double totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += haversineDistance(
        coordinates[i],
        coordinates[i + 1],
      );
    }
    return totalDistance;
  }

  int calculateTotalSteps(List<LatLng> coordinates) {
    int totalSteps = (calculateTotalDistance(coordinates) / 1.243).toInt();
    return totalSteps; // Example step calculation
  }
}
