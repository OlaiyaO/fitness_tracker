import 'package:fitness_tracker/presentation/screens/history_screen.dart';
import 'package:fitness_tracker/presentation/widgets/map_widget.dart';
import 'package:fitness_tracker/presentation/widgets/settings_icon_widget.dart';
import 'package:flutter/material.dart';

class FTHomeScreen extends StatefulWidget {
  const FTHomeScreen({super.key, required this.title});

  final String title;

  @override
  State<FTHomeScreen> createState() => _FTHomeScreenState();
}

class _FTHomeScreenState extends State<FTHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MapWidget(),
    HistoryScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: const [
          SettingsIcon(),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton.extended(
        onPressed: () {
        },
        label: const Text('Start'),
        icon: const Icon(Icons.not_started_outlined),
      ) : null,
    );
  }
}