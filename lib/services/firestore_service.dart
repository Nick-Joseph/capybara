import 'package:capybara/services/study_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              return null; // Skip problematic documents
            }
          })
          .whereType<Studies>()
          .toList();
    });
  }
}
