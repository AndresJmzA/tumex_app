import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// 2. Provider for AuthenticationService
final authServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(ref.watch(firebaseAuthProvider));
});

// 3. StreamProvider for auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationService(this._firebaseAuth);

  // Generates a custom ID based on the defined formula
  String _generateCustomId() {
    const accessLevelPrefix = 'use';
    final year = DateTime.now().year.toString().substring(2);
    final random = Random().nextInt(900000) + 100000; // 6-digit random number
    return '$accessLevelPrefix$year$random';
  }

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign In with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign Up with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String lastName,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final newUser = userCredential.user;
    if (newUser != null) {
      // Update display name in Firebase Auth
      await newUser.updateDisplayName(fullName);

      // Create user document in Firestore
      final userData = {
        'uid': newUser.uid,
        'custom_id': _generateCustomId(),
        'email': email,
        'display_name': fullName,
        'access_level': 'User',
        'created_time': FieldValue.serverTimestamp(),
        'edited_time': FieldValue.serverTimestamp(),
        'photo_url': null,
        'phone_number': null,
        'last_name': lastName,
        'doctor_id_card': null,
        'speciallity': null,
      };

      await _firestore.collection('Usuarios').doc(newUser.uid).set(userData);
    }

    return userCredential;
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
