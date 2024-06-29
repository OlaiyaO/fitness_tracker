import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalStorageService {
  Future<String?> saveScreenshot(Uint8List imageBytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      return filePath;
    } catch (e) {
      print('Error saving screenshot locally: $e');
      return null;
    }
  }

  Future<Uint8List?> loadScreenshot(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.png';
      final file = File(filePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error loading screenshot locally: $e');
      return null;
    }
  }
}
