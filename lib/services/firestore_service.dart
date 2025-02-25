import 'package:capybara/services/study_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final savedTrialsProvider = StreamProvider<List<Studies>>((ref) {
    final firestoreService = FirestoreService();
    return firestoreService
        .getSavedTrials(); // This is a Stream that will be listened to.
  });
  final firestoreServiceProvider = Provider<FirestoreService>((ref) {
    return FirestoreService(); // Initialize FirestoreService
  });

  /// Get current user ID safely
  String? get _userId => _auth.currentUser?.uid;

  /// Save a trial to Firestore
  Future<void> saveTrial(Studies study) async {
    if (_userId == null) return;

    String studyId =
        study.protocolSection?.identificationModule?.nctId ?? "default_id";

    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('savedTrials')
          .doc(studyId)
          .set(study.toJson());
      print("Study $studyId saved successfully.");
    } catch (e) {
      print("Error saving study $studyId: $e");
    }
  }

  /// Remove a saved trial from Firestore
  Future<void> removeTrial(String studyId) async {
    if (_userId == null) return;

    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('savedTrials')
          .doc(studyId)
          .delete();
      print("Study $studyId removed successfully.");
    } catch (e) {
      print("Error removing study $studyId: $e");
    }
  }

  /// Check if a trial is saved
  Future<bool> isTrialSaved(String studyId) async {
    if (_userId == null) return false;

    try {
      var doc = await _db
          .collection('users')
          .doc(_userId)
          .collection('savedTrials')
          .doc(studyId)
          .get();
      return doc.exists;
    } catch (e) {
      print("Error checking if study $studyId is saved: $e");
      return false;
    }
  }

  /// Get a stream of saved trials
  Stream<List<Studies>> getSavedTrials() {
    if (_userId == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(_userId)
        .collection('savedTrials')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return Studies.fromJson(doc.data());
            } catch (e) {
              print("Error parsing document ${doc.id}: $e");
              return null;
            }
          })
          .whereType<Studies>()
          .toList();
    });
  }
}

Future<void> deleteUserAccount(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    String uid = user.uid;

    // Step 1: Delete user data from Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();

    // Step 2: Delete user authentication record
    await user.delete();

    // Step 3: Sign out the user
    await FirebaseAuth.instance.signOut();
    // Step 4: Navigate to login page using GoRouter
    if (context.mounted) {
      context.go('/login'); // Redirect to login screen
    }

    print("Account deleted successfully.");
  } catch (e) {
    print("Error deleting account: $e");
  }
}
