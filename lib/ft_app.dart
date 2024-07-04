import 'dart:typed_data';

import 'package:fitness_tracker/auth_gate.dart';
import 'package:fitness_tracker/presentation/screens/activity_summary_screen.dart';
import 'package:fitness_tracker/presentation/screens/settings_page.dart';
import 'package:fitness_tracker/services/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/slider_bloc/slider_bloc.dart';
import 'blocs/slider_bloc/slider_event.dart';

class FTApp extends StatelessWidget {
  const FTApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = SharedPreferencesService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SliderBloc(sharedPreferencesService)..add(LoadSliderValues()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          // '/': (context) => const FTHomeScreen(title: 'Fitness Tracker',),
          '/settings': (context) => const SettingsPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/activity_summary') {
            final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
            final String localPath = args['localPath'];
            final String imageUrl = args['imageUrl'];
            final TimeOfDay startTime = args['startTime'];
            final TimeOfDay endTime = args['endTime'];
            final DateTime date = args['date'];
            final double distance = args['distance'];
            final int steps = args['steps'];
            return MaterialPageRoute(
              builder: (context) => ActivitySummaryScreen(
                localPath: localPath,
                imageUrl: imageUrl,
                startTime: startTime,
                endTime: endTime,
                date: date,
                distance: distance,
                steps: steps,
              ),
            );
          }
          return null;
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
