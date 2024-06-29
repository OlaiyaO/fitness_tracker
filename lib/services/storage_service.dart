import 'dart:typed_data';
import 'package:fitness_tracker/services/firestore_service.dart';
import 'firebase_storage_service.dart';
import 'local_storage_service.dart';

class StorageService {
  final FirebaseStorageService _firebaseStorage = FirebaseStorageService();
  final LocalStorageService _localStorage = LocalStorageService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> uploadImage(Uint8List imageBytes, String fileName) async {
    await _firebaseStorage.uploadScreenshot(imageBytes, fileName);
    await _localStorage.saveScreenshot(imageBytes, fileName);
  }

  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    _firestoreService.saveSessionData(sessionData);
  }
}
