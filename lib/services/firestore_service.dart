import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/activity_session_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      await _firestore.collection('sessions').add(sessionData);
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  Future<List<ActivitySession>> getSessionData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sessions').get();
      return snapshot.docs.map((doc) => ActivitySession.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
      return [];
    }
  }
}