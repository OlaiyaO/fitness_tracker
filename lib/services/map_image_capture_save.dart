import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_storage_service.dart';
import 'local_storage_service.dart';

class ScreenshotUtils {
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<Uint8List?> takeSnapshot(GoogleMapController controller) async {
    try {
      return await controller.takeSnapshot();
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }

  Future<String?> saveScreenshotLocally(
      Uint8List imageBytes, String fileName) async {
    return await _localStorageService.saveScreenshot(imageBytes, fileName);
  }

  Future<String?> uploadScreenshotToFirebase(
      Uint8List imageBytes, String fileName) async {
    return await _firebaseStorageService.uploadScreenshotToFirebase(
        imageBytes, fileName);
  }
}
