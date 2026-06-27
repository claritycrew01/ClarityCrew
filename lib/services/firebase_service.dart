import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();
  factory FirebaseService() => _instance;
  FirebaseService._() {
    _initInBackground();
  }

  bool _initialized = false;
  bool _initAttempted = false;

  void _initInBackground() {
    if (_initAttempted) return;
    _initAttempted = true;
    Future.microtask(() async {
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyANMxrDnttSSj5-Em9QeaqRd3meKOo33lo',
            appId: '1:684304642530:web:b65b6c299d15624ebf09bb',
            messagingSenderId: '684304642530',
            projectId: 'claritycrew-aa67a',
            authDomain: 'claritycrew-aa67a.firebaseapp.com',
            storageBucket: 'claritycrew-aa67a.firebasestorage.app',
            measurementId: 'G-CQR0FSNNVT',
          ),
        ).timeout(const Duration(seconds: 5));
        _initialized = true;
      } catch (_) {}
    });
  }

  bool get isInitialized => _initialized;
}
