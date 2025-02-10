import 'package:capybara/services/study_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save a trial to the user's saved trials collection
  Future<void> saveTrial(Studies study) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedTrials')
        .doc(study.protocolSection?.identificationModule?.nctId ??
            "default_id") // Unique ID
        .set(study.toJson()); // Save properly formatted JSON
  }

  /// Remove a saved trial
  Future<void> removeTrial(String studyId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await db
        .collection('users')
        .doc(user.uid)
        .collection('savedTrials')
        .doc(studyId)
        .delete();
  }

  Stream<List<Studies>> getSavedTrials() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]); // Return empty list if user is not logged in
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('savedTrials')
        .get()
        .then((snapshot) {
      //Prints firebase doc
      //for (var doc in snapshot.docs) {
      //   print("Document ID: ${doc.id}");
      //   print(
      //       "Firestore Data: ${doc.data()}");
      // }
    });

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedTrials')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) {
              print("Document ${doc.id} has null data.");
              return null;
            }
            try {
              return Studies.fromJson(data);
            } catch (e) {
              print("Error parsing document ${doc.id}: $e");
              return null; // Skip problematic documents
            }
          })
          .whereType<Studies>() // Remove any null values
          .toList();
    });
  }
}
