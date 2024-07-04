import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ActivitySession {
  final String? localPath;
  final String? imageUrl;
  final double distance;
  final DateTime date;
  final int steps;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ActivitySession({
    this.localPath,
    this.imageUrl,
    required this.distance,
    required this.date,
    required this.steps,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return {
      'localPath': localPath,
      'imageUrl': imageUrl,
      'distance': distance,
      'date': dateFormatter.format(date),
      'steps': steps,
      'startTime':
          '${startTime.hour}:${startTime.minute} ${startTime.period.toString().split('.').last}',
      'endTime':
          '${endTime.hour}:${endTime.minute} ${endTime.period.toString().split('.').last}',
    };
  }

  static ActivitySession fromMap(Map<String, dynamic> map) {
    return ActivitySession(
      localPath: map['localPath'],
      imageUrl: map['imageUrl'],
      distance: map['distance'],
      date: DateTime.parse(map['date']),
      steps: map['steps'],
      startTime: parseTimeOfDay(map['startTime']),
      endTime: parseTimeOfDay(map['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return {
      'localPath': localPath,
      'imageUrl': imageUrl,
      'distance': distance,
      'date': dateFormatter.format(date),
      'steps': steps,
      'startTime':
          '${startTime.hour}:${startTime.minute} ${startTime.period.toString().split('.').last}',
      'endTime':
          '${endTime.hour}:${endTime.minute} ${endTime.period.toString().split('.').last}',
    };
  }

  static ActivitySession fromJson(Map<String, dynamic> json) {
    return ActivitySession(
      localPath: json['loccalPath'],
      imageUrl: json['imageUrl'],
      distance: json['distance'],
      date: DateTime.parse(json['date']),
      steps: json['steps'],
      startTime: parseTimeOfDay(json['startTime']),
      endTime: parseTimeOfDay(json['endTime']),
    );
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final format = RegExp(r'(\d+):(\d+) (AM|PM)');
    final match = format.firstMatch(timeString);
    if (match != null) {
      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3)!;
      final hour24 = (period == 'PM' && hours != 12) ? hours + 12 : hours;
      return TimeOfDay(hour: hour24, minute: minutes);
    }
    return const TimeOfDay(
        hour: 0, minute: 0); // Default value in case of error
  }
}
