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
    apiKey: 'AIzaSyDlUjvaWqg6Frb_xKfujzik39WQaaXMyTU',
    appId: '1:117485835423:web:472fb8c5463674932bbeaa',
    messagingSenderId: '117485835423',
    projectId: 'stock-track-ke',
    authDomain: 'stock-track-ke.firebaseapp.com',
    storageBucket: 'stock-track-ke.appspot.com',
    measurementId: 'G-90R8FZRPY5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDc5KrnsMkdd91Pi237kx9Er_ZdS94Gm0',
    appId: '1:117485835423:android:d158b1b6d7cf19e62bbeaa',
    messagingSenderId: '117485835423',
    projectId: 'stock-track-ke',
    storageBucket: 'stock-track-ke.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDb-bjbFdX6hGUsVV_SImGCeYP4Ve4q0G0',
    appId: '1:117485835423:ios:0ff52bdd7e5a4ef12bbeaa',
    messagingSenderId: '117485835423',
    projectId: 'stock-track-ke',
    storageBucket: 'stock-track-ke.appspot.com',
    iosClientId: '117485835423-vgqgelvk2edtsgjcm2tql5klbr2ebnsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.stockTrackKe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDb-bjbFdX6hGUsVV_SImGCeYP4Ve4q0G0',
    appId: '1:117485835423:ios:0ff52bdd7e5a4ef12bbeaa',
    messagingSenderId: '117485835423',
    projectId: 'stock-track-ke',
    storageBucket: 'stock-track-ke.appspot.com',
    iosClientId: '117485835423-vgqgelvk2edtsgjcm2tql5klbr2ebnsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.stockTrackKe',
  );
}