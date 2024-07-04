import 'dart:io';

import 'package:fitness_tracker/utils/duration_calculation.dart';
import 'package:flutter/material.dart';

class ActivitySummaryScreen extends StatelessWidget {
  final String? localPath;
  final String? imageUrl;
  final DateTime date;
  final TimeOfDay startTime;
  final int steps;
  final TimeOfDay endTime;
  final double distance;

  const ActivitySummaryScreen({
    super.key,
    this.localPath,
    this.imageUrl,
    required this.date,
    required this.startTime,
    required this.steps,
    required this.endTime,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    Duration duration = calculateDuration(endTime, startTime);
    final primaryColor = Theme.of(context).colorScheme.primaryContainer;
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extends the body behind the AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: textColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Activity Details',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
        // Semi-transparent AppBar
        elevation: 24,
      ),
      body: Stack(
        children: [
          localPath != null
              ? Positioned.fill(child: Image.file(File('$localPath')))
              : Positioned.fill(child: Image.network('$imageUrl')),
          // Fills the available space with the image
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(24), left: Radius.circular(24))),
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distance:',
                          style: TextStyle(color: textColor),
                        ),
                        Text('${distance.floorToDouble() / 1000} km',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration:', style: TextStyle(color: textColor)),
                        Text('$hours hrs $minutes mins $seconds secs',
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Steps:', style: TextStyle(color: textColor)),
                        Text('$steps steps',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start Time:',
                            style: TextStyle(color: textColor)),
                        Text(startTime.format(context),
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date:', style: TextStyle(color: textColor)),
                        Text(date.toIso8601String().split('T').first,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
