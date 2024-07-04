import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadScreenshotToFirebase(Uint8List imageBytes, String fileName) async {
    try {
      Reference ref = _storage.ref().child('screenshots').child('$fileName.png');
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot downloadUrl = await uploadTask.whenComplete(() {});
      String url = await downloadUrl.ref.getDownloadURL();
      print('Screenshot uploaded to Firebase: $url');
      return url;
    } catch (e) {
      print('Error uploading screenshot to Firebase: $e');
      return null;
    }
  }

  Future<Uint8List?> downloadScreenshot(String fileName) async {
    try {
      final Reference ref = _storage.ref().child('screenshots/$fileName.png');
      final Uint8List? imageData = await ref.getData();
      return imageData;
    } catch (e) {
      print('Error downloading image from Firebase Storage: $e');
      return null;
    }
  }
}
