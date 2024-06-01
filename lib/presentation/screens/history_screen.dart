import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
            child: ListView.builder(
                  itemBuilder: (context, index) {
                  return createListTile(context, index);
                },
                  scrollDirection: Axis.vertical,

                ),
          ),
        ],
      ),
    );
  }
}

Widget? createListTile(BuildContext context, int index) {
  return ListTile(
    leading: const Icon(Icons.label),
    title: Text('Item $index'),
    subtitle: Text('Subtitle $index'),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () {
      // Handle the tap event here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped on item $index')),
      );
    },
  );
}