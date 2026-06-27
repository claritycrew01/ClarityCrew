import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();
  factory FirebaseService() => _instance;
  FirebaseService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'YOUR_API_KEY',
        appId: 'YOUR_APP_ID',
        messagingSenderId: 'YOUR_SENDER_ID',
        projectId: 'claritycrew',
        authDomain: 'claritycrew.firebaseapp.com',
        storageBucket: 'claritycrew.appspot.com',
        measurementId: 'YOUR_MEASUREMENT_ID',
      ),
    );
    _initialized = true;
  }

  bool get isInitialized => _initialized;
}
