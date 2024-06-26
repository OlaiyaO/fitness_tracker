// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBH2IeJ-Q-6ULGb0RQQCYCjkpW3IJ7wdek',
    appId: '1:221211995503:web:27bc0140cca91553408c9a',
    messagingSenderId: '221211995503',
    projectId: 'ride-tag',
    authDomain: 'ride-tag.firebaseapp.com',
    storageBucket: 'ride-tag.appspot.com',
    measurementId: 'G-C9RGD3PVHZ',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBe_ouuaS2nb00gz5jPKZisL9FU1ljtNrY',
    appId: '1:221211995503:ios:445a5b4c397774f3408c9a',
    messagingSenderId: '221211995503',
    projectId: 'ride-tag',
    storageBucket: 'ride-tag.appspot.com',
    iosBundleId: 'com.example.fitnessTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBH2IeJ-Q-6ULGb0RQQCYCjkpW3IJ7wdek',
    appId: '1:221211995503:web:3be879be2e443672408c9a',
    messagingSenderId: '221211995503',
    projectId: 'ride-tag',
    authDomain: 'ride-tag.firebaseapp.com',
    storageBucket: 'ride-tag.appspot.com',
    measurementId: 'G-HYQ5N62XXN',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBe_ouuaS2nb00gz5jPKZisL9FU1ljtNrY',
    appId: '1:221211995503:ios:445a5b4c397774f3408c9a',
    messagingSenderId: '221211995503',
    projectId: 'ride-tag',
    storageBucket: 'ride-tag.appspot.com',
    androidClientId: '221211995503-v03pn3dvs56i8q2ae6g24eibodjh91nb.apps.googleusercontent.com',
    iosClientId: '221211995503-o7k5r8lrdjn39ss3t5o1gfjt1t891nge.apps.googleusercontent.com',
    iosBundleId: 'com.example.fitnessTracker',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0wgrhOgKMSYGMXpQ4B3uvvKuJzKyxSSg',
    appId: '1:221211995503:android:35cf813ab6be6c50408c9a',
    messagingSenderId: '221211995503',
    projectId: 'ride-tag',
    storageBucket: 'ride-tag.appspot.com',
  );

}