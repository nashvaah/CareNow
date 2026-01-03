import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKoB9XRPy-pmnBeqy836b8fd_qyx8G-0E',
    appId: '1:1093768617024:web:031404b1071933feb193a5',
    messagingSenderId: '1093768617024',
    projectId: 'carenow-19214',
    authDomain: 'carenow-19214.firebaseapp.com',
    storageBucket: 'carenow-19214.firebasestorage.app',
    measurementId: 'G-SP1SQRR1FF',
  );
}