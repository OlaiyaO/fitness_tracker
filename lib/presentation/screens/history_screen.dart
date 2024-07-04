import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/data/models/activity_session_model.dart';
import 'package:fitness_tracker/utils/summay_page_navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/duration_calculation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          ),
          const Spacer(flex: 1),
          const Text('Workout History'),
          Expanded(
              flex: 15,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sessions')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          String? localPath = snap[index]['localPath'];
                          String? imageUrl = snap[index]['imageUrl'];

                          DateTime date = DateTime.parse(snap[index]['date']);
                          double distance = snap[index]['distance'];
                          int steps = snap[index]['steps'];
                          TimeOfDay startTime = ActivitySession.parseTimeOfDay(
                              snap[index]['startTime']);
                          TimeOfDay endTime = ActivitySession.parseTimeOfDay(
                              snap[index]['endTime']);
                          return createListTile(
                              context,
                              index,
                              localPath,
                              imageUrl,
                              date,
                              startTime,
                              endTime,
                              steps,
                              distance);
                        });
                  } else {
                    return const SizedBox();
                  }
                },
              )),
        ],
      ),
    );
  }
}

Widget? createListTile(
    BuildContext context,
    int index,
    String? localPath,
    String? imageUrl,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    int steps,
    double distance) {
  Duration duration = calculateDuration(endTime, startTime);
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  return ListTile(
    leading: ClipOval(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: localPath != null
            ? Image.file(
                File(localPath),
                fit: BoxFit.cover,
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
              ),
      ),
    ),
    title: Text(date.toIso8601String().split('T').first),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${distance.floorToDouble() / 1000} km'),
        Text('$steps steps')
      ],
    ),
    trailing: Text('$hours : $minutes'),
    onTap: () {
      navigateToSummaryScreen(context, localPath!, imageUrl!, startTime,
          endTime, date, distance, steps); // Handle the tap event here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped on item $index')),
      );
    },
  );
}
