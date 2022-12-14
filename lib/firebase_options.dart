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
    apiKey: 'AIzaSyAFdexOp9CG4lpGDKKZLhb0I8yKy3Rjv5Q',
    appId: '1:443888611594:web:f5997bbd696a2285718af3',
    messagingSenderId: '443888611594',
    projectId: 'flame-pong',
    authDomain: 'flame-pong.firebaseapp.com',
    storageBucket: 'flame-pong.appspot.com',
    measurementId: 'G-W9XW3BV7WH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzsX37KODnVJIQIJnhtQEiC9p1vsfBYQA',
    appId: '1:443888611594:android:035898182c6a3f5a718af3',
    messagingSenderId: '443888611594',
    projectId: 'flame-pong',
    storageBucket: 'flame-pong.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTsMmfZ3wTjx1Z7bSOVtv6TrFLd-ZTaVE',
    appId: '1:443888611594:ios:b14c904dad954473718af3',
    messagingSenderId: '443888611594',
    projectId: 'flame-pong',
    storageBucket: 'flame-pong.appspot.com',
    iosClientId: '443888611594-1j6bt10ufua13h43tc83qppm3bv0vnj4.apps.googleusercontent.com',
    iosBundleId: 'com.daemonw.pong.flamePong',
  );
}
