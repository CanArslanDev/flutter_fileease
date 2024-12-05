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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD3Zr7yMGM4FUwZp_5KtbC35w-712DLPZg',
    appId: '1:239466517804:web:a58d6d36cbca8e8fd04889',
    messagingSenderId: '239466517804',
    projectId: 'flutter-fileease',
    authDomain: 'flutter-fileease.firebaseapp.com',
    storageBucket: 'flutter-fileease.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOgm1DH3ecxqs7NX2NXNaWwf-tPdY75BY',
    appId: '1:239466517804:android:9fd5402c387fea47d04889',
    messagingSenderId: '239466517804',
    projectId: 'flutter-fileease',
    storageBucket: 'flutter-fileease.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeTKO_rF_s9g1Cah0-YkBqmrH3wHcEs3w',
    appId: '1:239466517804:ios:a541c3f4e816883ed04889',
    messagingSenderId: '239466517804',
    projectId: 'flutter-fileease',
    storageBucket: 'flutter-fileease.appspot.com',
    iosBundleId: 'com.fileease',
  );
}
