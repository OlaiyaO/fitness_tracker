
import 'package:fitness_tracker/auth_gate.dart';
import 'package:fitness_tracker/presentation/screens/settings_page.dart';
import 'package:flutter/material.dart';

import '../../ft_app.dart';


class FTApp extends StatelessWidget {
  const FTApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        // '/': (context) => const FTHomeScreen(title: 'Fitness Tracker',),
        '/settings': (context) => const SettingsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

