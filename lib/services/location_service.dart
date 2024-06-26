import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Stream<LatLng> getLocationUpdates() async* {
  Location location = Location();

  location.changeSettings(accuracy: LocationAccuracy.high);

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  await for (final locationData in location.onLocationChanged) {
    if (locationData.longitude != null && locationData.latitude != null) {
      yield LatLng(locationData.latitude!, locationData.longitude!);
    }
  }
}
