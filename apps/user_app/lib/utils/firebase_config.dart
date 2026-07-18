import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class FirebaseConfig {
  // 🛡️ SHARED CORE CONFIG
  static const String _apiKey = "AIzaSyDFT0A-DodhyqsogAn7bpQHSjSFUtxKDpo";
  static const String _projectId = "espy-453d3";
  static const String _senderId = "425540347151";
  static const String _bucket = "espy-453d3.firebasestorage.app";

  // 🏛️ ADMIN APP (WEB)
  static const FirebaseOptions adminWeb = FirebaseOptions(
    apiKey: _apiKey,
    authDomain: "espy-453d3.firebaseapp.com",
    projectId: _projectId,
    storageBucket: _bucket,
    messagingSenderId: _senderId,
    appId: "1:425540347151:web:bbca01d8a4eef075d8ca7a",
    measurementId: "G-42V44VK60V",
  );

  // 👤 USER APP (WEB)
  static const FirebaseOptions userWeb = FirebaseOptions(
    apiKey: _apiKey,
    authDomain: "espy-453d3.firebaseapp.com",
    projectId: _projectId,
    storageBucket: _bucket,
    messagingSenderId: _senderId,
    appId: "1:425540347151:web:25639b3bd0a80a31d8ca7a",
    measurementId: "G-5T8N8NE50D",
  );

  // 📱 MOBILE APP (ANDROID)
  // Correct appId from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: "1:425540347151:android:df5333809da60849d8ca7a",
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _bucket,
  );

  // 🍎 MOBILE APP (IOS)
  // Correct appId from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyCzOYSBzhsPKyljvP-XBqqKuYSOUObumCM",
    appId: "1:425540347151:ios:3b4c9a5c65a76662d8ca7a",
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _bucket,
    iosBundleId: "com.espyprotocol.user",
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      final String host = web.window.location.hostname;
      // Detect based on Hosting site IDs
      if (host.contains('espy-253f7') || host.contains('espy-user')) {
        return userWeb;
      }
      // Default to Admin
      return adminWeb;
    }
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        // Fallback to userWeb as a safe configuration for cross-platform defaults
        return userWeb;
    }
  }
}
