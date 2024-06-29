import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitySession {
  final double walkingDistance;
  final double runningDistance;
  final double cyclingDistance;
  final Duration walkingTime;
  final Duration runningTime;
  final Duration cyclingTime;
  final int steps;
  final DateTime startTime;
  final DateTime endTime;

  ActivitySession({
    required this.walkingDistance,
    required this.runningDistance,
    required this.cyclingDistance,
    required this.walkingTime,
    required this.runningTime,
    required this.cyclingTime,
    required this.steps,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'walkingDistance': walkingDistance,
      'runningDistance': runningDistance,
      'cyclingDistance': cyclingDistance,
      'walkingTime': walkingTime.inSeconds,
      'runningTime': runningTime.inSeconds,
      'cyclingTime': cyclingTime.inSeconds,
      'steps': steps,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  static ActivitySession fromMap(Map<String, dynamic> map) {
    return ActivitySession(
      walkingDistance: map['walkingDistance'],
      runningDistance: map['runningDistance'],
      cyclingDistance: map['cyclingDistance'],
      walkingTime: Duration(seconds: map['walkingTime']),
      runningTime: Duration(seconds: map['runningTime']),
      cyclingTime: Duration(seconds: map['cyclingTime']),
      steps: map['steps'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walkingDistance': walkingDistance,
      'runningDistance': runningDistance,
      'cyclingDistance': cyclingDistance,
      'walkingTime': walkingTime.inSeconds,
      'runningTime': runningTime.inSeconds,
      'cyclingTime': cyclingTime.inSeconds,
      'steps': steps,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  static ActivitySession fromJson(Map<String, dynamic> json) {
    return ActivitySession(
      walkingDistance: json['walkingDistance'],
      runningDistance: json['runningDistance'],
      cyclingDistance: json['cyclingDistance'],
      walkingTime: Duration(seconds: json['walkingTime']),
      runningTime: Duration(seconds: json['runningTime']),
      cyclingTime: Duration(seconds: json['cyclingTime']),
      steps: json['steps'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection('activitySessions').add(toMap());
  }
}
