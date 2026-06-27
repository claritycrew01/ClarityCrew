import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  AuthService() {
    _ensureFirebase();
  }

  void _ensureFirebase() {
    if (_auth != null) return;
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    } catch (_) {
      Future.delayed(const Duration(milliseconds: 500), _ensureFirebase);
    }
  }

  Future<void> _waitForFirebase() async {
    if (_auth != null) return;
    for (int i = 0; i < 30; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_auth != null) return;
    }
  }

  Stream<User?> get authStateChanges =>
    _auth?.authStateChanges() ?? const Stream.empty();
  User? get currentUser => _auth?.currentUser;
  bool get isSignedIn => _auth?.currentUser != null;

  Future<User?> signInWithEmail(String email, String password) async {
    await _waitForFirebase();
    if (_auth == null || _firestore == null) return null;
    final result = await _auth!.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _updateLastActive(result.user!.uid);
    return result.user;
  }

  Future<User?> signUpWithEmail(
      String email, String password, String displayName) async {
    await _waitForFirebase();
    if (_auth == null || _firestore == null) return null;
    final result = await _auth!.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.updateDisplayName(displayName);
    await _createUserProfile(result.user!.uid, displayName, email);
    return result.user;
  }

  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
  }

  Future<void> _createUserProfile(
      String uid, String name, String email) async {
    await _firestore!.collection('users').doc(uid).set({
      'displayName': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastActive': FieldValue.serverTimestamp(),
      'preferences': {
        'textScale': 1.0,
        'contrastLevel': 1.0,
        'reducedMotion': false,
        'focusMode': false,
      },
      'settings': {
        'notificationsEnabled': true,
      },
    });
  }

  Future<void> _updateLastActive(String uid) async {
    await _firestore!.collection('users').doc(uid).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
