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
    apiKey: String.fromEnvironment('GOOGLE_API_KEY_WEB'),
    appId: '1:859419283461:web:5f662b95006cb88eaccc6c',
    messagingSenderId: '859419283461',
    projectId: 'hcms-484b9',
    authDomain: 'hcms-484b9.firebaseapp.com',
    storageBucket: 'hcms-484b9.firebasestorage.app',
    measurementId: 'G-ZGL58VRN3V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIalh5xs8rvxwRsTQa5XKTQyelEULuAYI',
    appId: '1:859419283461:android:174e0bd58b315e55accc6c',
    messagingSenderId: '859419283461',
    projectId: 'hcms-484b9',
    storageBucket: 'hcms-484b9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('GOOGLE_API_KEY_IOS'),
    appId: '1:859419283461:ios:2d5aac5b71b06359accc6c',
    messagingSenderId: '859419283461',
    projectId: 'hcms-484b9',
    storageBucket: 'hcms-484b9.firebasestorage.app',
    iosBundleId: 'com.example.hcms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment('GOOGLE_API_KEY_MACOS'),
    appId: '1:859419283461:ios:2d5aac5b71b06359accc6c',
    messagingSenderId: '859419283461',
    projectId: 'hcms-484b9',
    storageBucket: 'hcms-484b9.firebasestorage.app',
    iosBundleId: 'com.example.hcms',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: String.fromEnvironment('GOOGLE_API_KEY_WINDOWS'),
    appId: '1:859419283461:web:052e56ef99e298b6accc6c',
    messagingSenderId: '859419283461',
    projectId: 'hcms-484b9',
    authDomain: 'hcms-484b9.firebaseapp.com',
    storageBucket: 'hcms-484b9.firebasestorage.app',
    measurementId: 'G-25ZQ303B5E',
  );
}
