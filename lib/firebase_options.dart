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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMLp39qeO0VhsInF8W7JRuXloYqqIWsss',
    appId: '1:864810328858:android:b82671a61b1a45715dc2a3',
    messagingSenderId: '864810328858',
    projectId: 'wheredidispend-ai',
    storageBucket: 'wheredidispend-ai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVP3ZaTdZXelyHEDWbJKC5I7Bhh-jUnRg',
    appId: '1:864810328858:ios:9d0e15799cf8393f5dc2a3',
    messagingSenderId: '864810328858',
    projectId: 'wheredidispend-ai',
    storageBucket: 'wheredidispend-ai.appspot.com',
    androidClientId:
        '864810328858-c0po1mjcv79krap53n8v83ve9cisoh3k.apps.googleusercontent.com',
    iosClientId:
        '864810328858-mu1vrps906hp2v1ctirj2eov06n1ki9u.apps.googleusercontent.com',
    iosBundleId: 'com.wheredidispend.app',
  );
}
