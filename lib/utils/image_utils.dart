import 'dart:async';
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/map_image_capture_save.dart';

class ImageUtils {
  static Future<Map<String, String?>> takeSnapshotAndSave(
      Completer<GoogleMapController> controller,
      ScreenshotUtils screenshotUtils,
      ) async {

    Map<String, String?> imagePaths;
    Uint8List? imageBytes = await screenshotUtils.takeSnapshot(await controller.future);
    String fileName = 'session_screenshot_${DateTime.now().millisecondsSinceEpoch}';

    String? localPath = await screenshotUtils.saveScreenshotLocally(imageBytes!, fileName);
    String? imageUrl = await screenshotUtils.uploadScreenshotToFirebase(imageBytes, fileName);

    imagePaths = {'localPath': localPath, 'imageUrl': imageUrl};

    return imagePaths;
  }
}
