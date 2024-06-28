import 'package:google_maps_flutter/google_maps_flutter.dart';
// kalman_filter.dart
class KalmanFilter {
  double processNoise;
  double measurementNoise;
  double estimatedError;
  double lastEstimate;

  KalmanFilter({
    required this.processNoise,
    required this.measurementNoise,
    required this.estimatedError,
    required this.lastEstimate,
  });

  double filter(double measurement) {
    // Prediction update
    double prioriEstimate = lastEstimate;
    double prioriError = estimatedError + processNoise;

    // Measurement update
    double gain = prioriError / (prioriError + measurementNoise);
    double estimate = prioriEstimate + gain * (measurement - prioriEstimate);
    double estimateError = (1 - gain) * prioriError;

    // Update state
    lastEstimate = estimate;
    estimatedError = estimateError;

    return estimate;
  }
}

class KalmanLatLng {
  KalmanFilter latFilter;
  KalmanFilter lngFilter;

  KalmanLatLng()
      : latFilter = KalmanFilter(
    processNoise: 0.1,
    measurementNoise: 1.0,
    estimatedError: 1.0,
    lastEstimate: 0.0,
  ),
        lngFilter = KalmanFilter(
          processNoise: 0.1,
          measurementNoise: 1.0,
          estimatedError: 1.0,
          lastEstimate: 0.0,
        );

  LatLng filter(LatLng position) {
    double filteredLat = latFilter.filter(position.latitude);
    double filteredLng = lngFilter.filter(position.longitude);
    return LatLng(filteredLat, filteredLng);
  }
}