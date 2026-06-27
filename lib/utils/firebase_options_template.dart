class DefaultFirebaseOptions {
  static const FirebaseConfig current = FirebaseConfig(
    apiKey: 'AIzaSyANMxrDnttSSj5-Em9QeaqRd3meKOo33lo',
    appId: '1:684304642530:web:b65b6c299d15624ebf09bb',
    messagingSenderId: '684304642530',
    projectId: 'claritycrew-aa67a',
    authDomain: 'claritycrew-aa67a.firebaseapp.com',
    storageBucket: 'claritycrew-aa67a.firebasestorage.app',
    measurementId: 'G-CQR0FSNNVT',
  );
}

class FirebaseConfig {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String authDomain;
  final String storageBucket;
  final String measurementId;

  const FirebaseConfig({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.authDomain,
    required this.storageBucket,
    required this.measurementId,
  });
}
