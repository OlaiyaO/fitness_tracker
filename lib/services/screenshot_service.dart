import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/google_maps_static_config.dart';

class ScreenshotService {
  Future<Uint8List?> captureMapImage(List<LatLng> waypoints) async {
    return await GoogleMapsStaticConfig.fetchStaticMapImage(
      waypoints: waypoints,
      zoom: 15.0,
      viewportSize: Size(600, 300),
    );
  }
}
