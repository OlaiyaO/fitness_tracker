import 'package:flutter/material.dart';
import '../data/models/activity_session_model.dart';
import 'firestore_service.dart';

class SessionManager {
  static Future<String?> createSession({
    required DateTime date,
    required TimeOfDay startTime,
  }) async {
    ActivitySession session = ActivitySession(
      distance: 0.0,
      date: date,
      steps: 0,
      startTime: startTime,
      endTime: startTime,
    );

    Map<String, dynamic> sessionData = session.toMap();
    return await FirestoreService().saveSessionData(sessionData);
  }

  static Future<void> updateSession({
    String? localPath,
    String? imageUrl,
    required String sessionId,
    required double distance,
    required int steps,
    required TimeOfDay endTime,
    required TimeOfDay startTime,
  }) async {
    // Retrieve the current session data from Firestore (assuming you have a method for this)
    ActivitySession currentSession = await FirestoreService().getSessionById(sessionId);

    ActivitySession updatedSession = ActivitySession(
      localPath: localPath ?? currentSession.localPath,
      imageUrl: imageUrl ?? currentSession.imageUrl,
      distance: distance,
      date: currentSession.date,
      steps: steps,
      startTime: startTime,
      endTime: endTime,
    );

    Map<String, dynamic> sessionData = updatedSession.toMap();
    await FirestoreService().updateSessionData(sessionId, sessionData);
  }
}
