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
        apiKey: 'AIzaSyANMxrDnttSSj5-Em9QeaqRd3meKOo33lo',
        appId: '1:684304642530:web:b65b6c299d15624ebf09bb',
        messagingSenderId: '684304642530',
        projectId: 'claritycrew-aa67a',
        authDomain: 'claritycrew-aa67a.firebaseapp.com',
        storageBucket: 'claritycrew-aa67a.firebasestorage.app',
        measurementId: 'G-CQR0FSNNVT',
      ),
    );
    _initialized = true;
  }

  bool get isInitialized => _initialized;
}
