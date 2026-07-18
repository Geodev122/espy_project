import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

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

  // 📱 MOBILE APP (NATIVE)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: "1:425540347151:android:725b89a8eef075d8ca7a", // Derived placeholder
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _bucket,
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      final String host = html.window.location.hostname;
      // Detect based on Firebase Hosting site IDs
      if (host.contains('espy-253f7') || host.contains('espy-user')) {
        return userWeb;
      }
      // Default to Admin or check for espy-453d3
      return adminWeb;
    }
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        // Use userWeb config as a safe fallback for native platforms 
        // to ensure measureId/appId consistency with seeker apps
        return userWeb;
    }
  }
}
