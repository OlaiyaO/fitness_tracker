import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'ft_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseUIAuth.configureProviders([
  //   GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
  //   AppleProvider(),
  // ]);
  runApp(const FTApp());
}
