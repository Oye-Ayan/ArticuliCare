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
    apiKey: 'AIzaSyAObXJm2ytqXPL-iYLB9U_M01q_4iya9dY',
    appId: '1:322252487406:web:7a6e609175cee71fba51ff',
    messagingSenderId: '322252487406',
    projectId: 'articuli-care',
    authDomain: 'articuli-care.firebaseapp.com',
    storageBucket: 'articuli-care.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCd2XEZxEDB0lfyv22M4OygwvzYc8glT-Y',
    appId: '1:322252487406:android:aa1de4b8d02854cdba51ff',
    messagingSenderId: '322252487406',
    projectId: 'articuli-care',
    storageBucket: 'articuli-care.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfwe1FohentTXIQHkLDQ5Y8pg7vafDhxc',
    appId: '1:322252487406:ios:4dfc1b31d3546f37ba51ff',
    messagingSenderId: '322252487406',
    projectId: 'articuli-care',
    storageBucket: 'articuli-care.firebasestorage.app',
    iosBundleId: 'com.example.articulicare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfwe1FohentTXIQHkLDQ5Y8pg7vafDhxc',
    appId: '1:322252487406:ios:4dfc1b31d3546f37ba51ff',
    messagingSenderId: '322252487406',
    projectId: 'articuli-care',
    storageBucket: 'articuli-care.firebasestorage.app',
    iosBundleId: 'com.example.articulicare',
  );
}
