import 'package:flutter/material.dart'; // Import for TimeOfDay

import 'package:flutter/material.dart';

void main() {
  TimeOfDay startTime = TimeOfDay(hour: 22, minute: 30); // Example start time: 10:30 PM
  TimeOfDay endTime = TimeOfDay(hour: 1, minute: 15); // Example end time: 1:15 AM (next day)

  Duration duration = calculateDuration(startTime, endTime);

  print('Duration: ${duration.inHours} hours, ${duration.inMinutes % 60} minutes, ${duration.inSeconds % 60} seconds');
}

Duration calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
  // Convert TimeOfDay to minutes since midnight
  int startMinutes = startTime.hour * 60 + startTime.minute;
  int endMinutes = endTime.hour * 60 + endTime.minute;

  // If the end time is before the start time, it means it's on the next day
  if (endMinutes < startMinutes) {
    endMinutes += 24 * 60; // Add 24 hours in minutes
  }

  // Calculate the difference in minutes
  int differenceInMinutes = endMinutes - startMinutes;

  // Create a Duration object from the difference in minutes
  Duration duration = Duration(minutes: differenceInMinutes);

  return duration;
}

