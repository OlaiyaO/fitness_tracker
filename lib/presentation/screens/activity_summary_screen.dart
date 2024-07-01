import 'package:fitness_tracker/data/models/activity_session_model.dart';
import 'package:flutter/material.dart';

class ActivitySummaryScreen extends StatelessWidget {
  final Image mapImage;
  final ActivitySession session;

  const ActivitySummaryScreen({
    super.key,
    required this.mapImage,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Activity Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: mapImage),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDataRow('Walking Distance:',
                      '${session.walkingDistance.toStringAsFixed(2)} km'),
                  _buildDataRow('Running Distance:',
                      '${session.runningDistance.toStringAsFixed(2)} km'),
                  _buildDataRow('Cycling Distance:',
                      '${session.cyclingDistance.toStringAsFixed(2)} km'),
                  _buildDataRow(
                      'Total Time:',
                      _formatDuration(session.walkingTime +
                          session.runningTime +
                          session.cyclingTime)),
                  _buildDataRow('Steps:', '${session.steps}'),
                  _buildDataRow(
                      'Start Time:', _formatDateTime(session.startTime)),
                  _buildDataRow('End Time:', _formatDateTime(session.endTime)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
