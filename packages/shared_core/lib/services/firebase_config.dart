import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1zjDvYC6Rq6AVwjSsDpvhZJuCYtyx31s',
    appId: '1:901792627653:android:0792e2c2ab42ea6bf6e9ac',
    messagingSenderId: '901792627653',
    projectId: 'hope-bearer-award',
    storageBucket: 'hope-bearer-award.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoDoITldWZHob7NDFRntKHcyB06CPgKjI',
    appId: '1:901792627653:ios:placeholder', // Need actual iOS App ID if available
    messagingSenderId: '901792627653',
    projectId: 'hope-bearer-award',
    storageBucket: 'hope-bearer-award.firebasestorage.app',
    iosBundleId: 'com.hopesupportsuit.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLms3fjwWnBC3aQlxafU6hF7m2Egw3KCc',
    authDomain: 'hope-bearer-award.firebaseapp.com',
    projectId: 'hope-bearer-award',
    storageBucket: 'hope-bearer-award.firebasestorage.app',
    messagingSenderId: '901792627653',
    appId: '1:901792627653:web:d215087d3416ac8ff6e9ac',
    measurementId: 'G-QZKLKL4ZF8',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }
}
