import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadScreenshot(Uint8List imageBytes, String fileName) async {
    try {
      final Reference ref = _storage.ref().child('screenshots/$fileName.png');
      final UploadTask uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
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
