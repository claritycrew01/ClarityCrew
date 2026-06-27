import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;

  Future<User?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _updateLastActive(result.user!.uid);
    return result.user;
  }

  Future<User?> signUpWithEmail(
      String email, String password, String displayName) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.updateDisplayName(displayName);
    await _createUserProfile(result.user!.uid, displayName, email);
    return result.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _createUserProfile(
      String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).set({
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
    await _firestore.collection('users').doc(uid).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
