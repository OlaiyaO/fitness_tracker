import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> getLocationUpdates(Function(LatLng) onLocationUpdated) async {
  Location location = Location();

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

  location.onLocationChanged.listen((LocationData locationData) {
    if (locationData.longitude != null && locationData.latitude != null) {
      LatLng currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      onLocationUpdated(currentPosition);
    }
  });
}
