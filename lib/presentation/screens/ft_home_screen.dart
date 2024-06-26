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

  bool isDrawing = false;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(MapWidget(
      onStartButtonPressed: startDrawing,
      onStopButtonPressed: stopDrawing,
    ));
    _screens.add(const HistoryScreen());
  }

  void startDrawing() {
    setState(() {
      isDrawing = true;
    });
  }

  void stopDrawing() {
    setState(() {
      isDrawing = false;
      // TODO: Add logic to send data to Firebase and update the history screen
    });
  }

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
    );
  }
}
