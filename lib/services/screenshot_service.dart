import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotService {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<Uint8List?> captureScreenshot(GlobalKey key) async {
    try {
      return await _screenshotController.captureFromWidget(
        RepaintBoundary(
          key: key,
          child: key.currentContext!.widget,
        ),
        pixelRatio: 2.0,
      );
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }

  Future<String?> saveScreenshotToFile(Uint8List imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);
      return imagePath;
    } catch (e) {
      print('Error saving screenshot: $e');
      return null;
    }
  }
}
