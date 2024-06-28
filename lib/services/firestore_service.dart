import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      await _firestore.collection('sessions').add(sessionData);
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }
}