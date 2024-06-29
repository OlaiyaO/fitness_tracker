import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
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

  Stream<LatLng> getLocationUpdates() async* {
    await checkServiceAndPermission();

    _location.changeSettings(accuracy: LocationAccuracy.high);

    await for (final locationData in _location.onLocationChanged) {
      if (locationData.latitude != null && locationData.longitude != null) {
        yield LatLng(locationData.latitude!, locationData.longitude!);
      }
    }
  }
}
