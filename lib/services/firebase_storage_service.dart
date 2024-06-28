import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(String filePath) async {
    try {
      Reference ref = _storage.ref().child('screenshots/${DateTime.now().microsecondsSinceEpoch}.png');
      UploadTask uploadTask = ref.putFile(File(filePath));
      await uploadTask.whenComplete(() {});
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file to Firebase: $e');
      return null;
    }
  }
}
