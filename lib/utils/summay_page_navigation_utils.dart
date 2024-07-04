import 'package:flutter/material.dart';
import 'package:path/path.dart';

void navigateToSummaryScreen(
    BuildContext context,
    String localPath,
    String imageUrl,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double distance,
    int steps) {
  Navigator.pushNamed(
    context,
    '/activity_summary',
    arguments: <String, dynamic>{
      'localPath': localPath,
      'imageUrl': imageUrl,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'distance': distance,
      'steps': steps,
    },
  );
}