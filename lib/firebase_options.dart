// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD_3auIGaSo3Zrj99PkLQdLWPfJPKxTZqg',
    appId: '1:781052775150:web:8d7cb426d1788079e041ff',
    messagingSenderId: '781052775150',
    projectId: 'digi1-1a208',
    authDomain: 'digi1-1a208.firebaseapp.com',
    storageBucket: 'digi1-1a208.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrtvJL8cEFJ-jU_LHRiFWXmh-GcBaqwQM',
    appId: '1:781052775150:android:528e138a9267b537e041ff',
    messagingSenderId: '781052775150',
    projectId: 'digi1-1a208',
    storageBucket: 'digi1-1a208.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADf5sQ0ed9Jr3-Zst7bo67EcDTobWcfHY',
    appId: '1:781052775150:ios:5d92d3fa24c88ae9e041ff',
    messagingSenderId: '781052775150',
    projectId: 'digi1-1a208',
    storageBucket: 'digi1-1a208.appspot.com',
    iosBundleId: 'com.example.digi1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADf5sQ0ed9Jr3-Zst7bo67EcDTobWcfHY',
    appId: '1:781052775150:ios:15ec8e61a9adf59de041ff',
    messagingSenderId: '781052775150',
    projectId: 'digi1-1a208',
    storageBucket: 'digi1-1a208.appspot.com',
    iosBundleId: 'com.example.digi1.RunnerTests',
  );
}