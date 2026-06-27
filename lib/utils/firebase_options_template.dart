class DefaultFirebaseOptions {
  static const FirebaseConfig current = FirebaseConfig(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'claritycrew',
    authDomain: 'claritycrew.firebaseapp.com',
    storageBucket: 'claritycrew.appspot.com',
    measurementId: 'YOUR_MEASUREMENT_ID',
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
