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
    apiKey: 'AIzaSyAbuykjVcXJUjbhvfKdvDhhXMeobmNN-IE',
    appId: '1:178553912624:web:da2ba0cb826b7dbb66dcf5',
    messagingSenderId: '178553912624',
    projectId: 'connection-alley',
    authDomain: 'connection-alley.firebaseapp.com',
    storageBucket: 'connection-alley.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuO3xI0GUc1T6MEORuU8qc22BAE2a5ecI',
    appId: '1:178553912624:android:33f71486e62ea2cb66dcf5',
    messagingSenderId: '178553912624',
    projectId: 'connection-alley',
    storageBucket: 'connection-alley.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2EJv0AY_0Y59I0ixC_ukSaXSK2vzjWz4',
    appId: '1:178553912624:ios:1cdf29fe5e12c99866dcf5',
    messagingSenderId: '178553912624',
    projectId: 'connection-alley',
    storageBucket: 'connection-alley.appspot.com',
    iosBundleId: 'com.example.connectionAlley',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2EJv0AY_0Y59I0ixC_ukSaXSK2vzjWz4',
    appId: '1:178553912624:ios:a888a909d1b04e6c66dcf5',
    messagingSenderId: '178553912624',
    projectId: 'connection-alley',
    storageBucket: 'connection-alley.appspot.com',
    iosBundleId: 'com.example.connectionAlley.RunnerTests',
  );
}