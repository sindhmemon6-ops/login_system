// File generated for hack1-6ae9c Firebase project configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9LuymDxPS1WYa_QyBVQSOemMhDnCeIZk',
    appId: '1:644679857042:android:05c5a6503bf6ef1d2c474b',
    messagingSenderId: '644679857042',
    projectId: 'hack1-6ae9c',
    storageBucket: 'hack1-6ae9c.firebasestorage.app',
  );
}
