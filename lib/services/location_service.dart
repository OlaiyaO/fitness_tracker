import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/kalman_filter.dart';

class LocationService {
  final KalmanLatLng _kalmanLatLng = KalmanLatLng();
  final Location _location = Location();

  Future<void> checkServiceAndPermission() async {
    await _requestService();
    await _requestPermission();
  }

  Future<bool> _requestService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _requestPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      print("Error getting current location: $e");
      return null;
    }
  }

  Stream<LocationData> getLocationUpdates() async* {
    await checkServiceAndPermission();

    _location.changeSettings(accuracy: LocationAccuracy.high);

    await for (final locationData in _location.onLocationChanged) {
      if (locationData.latitude != null && locationData.longitude != null) {
        yield locationData;
      }
    }
  }
  LatLng filterLocation(LocationData locationData) {
    LatLng newPosition = LatLng(locationData.latitude!, locationData.longitude!);
    return _kalmanLatLng.filter(newPosition);
  }
}
