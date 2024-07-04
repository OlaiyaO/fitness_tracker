import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/activity_session_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      DocumentReference docRef = await _firestore.collection('sessions').add(sessionData);
      return docRef.id;
    } catch (e) {
      print('Error saving data to Firestore: $e');
      return null;
    }
  }

  Future<void> updateSessionData(String sessionId, Map<String, dynamic> sessionData) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update(sessionData);
    } catch (e) {
      print('Error updating data in Firestore: $e');
    }
  }

  Future<ActivitySession> getSessionById(String sessionId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('sessions').doc(sessionId).get();
      return ActivitySession.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
      throw Exception('Failed to retrieve session');
    }
  }

  Future<List<ActivitySession>> getSessionData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sessions').get();
      return snapshot.docs
          .map((doc) => ActivitySession.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
      return [];
    }
  }
}
