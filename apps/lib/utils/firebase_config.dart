import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFT0A-DodhyqsogAn7bpQHSjSFUtxKDpo',
    appId: '1:425540347151:android:placeholder', // Need actual Android App ID
    messagingSenderId: '425540347151',
    projectId: 'espy-453d3',
    storageBucket: 'espy-453d3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFT0A-DodhyqsogAn7bpQHSjSFUtxKDpo',
    appId: '1:425540347151:ios:placeholder', // Need actual iOS App ID
    messagingSenderId: '425540347151',
    projectId: 'espy-453d3',
    storageBucket: 'espy-453d3.firebasestorage.app',
    iosBundleId: 'com.espyprotocol.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFT0A-DodhyqsogAn7bpQHSjSFUtxKDpo',
    authDomain: 'espy-453d3.firebaseapp.com',
    projectId: 'espy-453d3',
    storageBucket: 'espy-453d3.firebasestorage.app',
    messagingSenderId: '425540347151',
    appId: '1:425540347151:web:bbca01d8a4eef075d8ca7a',
    measurementId: 'G-42V44VK60V',
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
