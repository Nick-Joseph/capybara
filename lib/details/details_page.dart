import 'package:capybara/services/firestore_service.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/widgets/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudyDetailPage extends StatefulWidget {
  final Studies study;

  const StudyDetailPage({super.key, required this.study});

  @override
  State<StudyDetailPage> createState() => _StudyDetailPageState();
}

class _StudyDetailPageState extends State<StudyDetailPage> {
  final FirestoreService firestoreService = FirestoreService();
  bool isSaved = false; // Track if the trial is saved
  User? user; // Track user authentication status

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      _checkIfSaved();
    }
  }

  /// Check if the study is saved in Firestore (only if logged in)
  void _checkIfSaved() async {
    bool saved = await firestoreService.isTrialSaved(
        widget.study.protocolSection?.identificationModule?.nctId ?? '');
    setState(() {
      isSaved = saved;
    });
  }

  /// Handle Save or Unsave action
  void _toggleSave(BuildContext context) async {
    if (user == null) {
      _showLoginPrompt(context); // 🚀 Ask user to log in before saving
      return;
    }

    if (isSaved) {
      await firestoreService.removeTrial(
          widget.study.protocolSection?.identificationModule?.nctId ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Removed from your trials!")),
      );
    } else {
      await firestoreService.saveTrial(widget.study);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved to your trials!")),
      );
    }

    // Update UI
    setState(() {
      isSaved = !isSaved;
    });
  }

  /// Show Login Prompt if Guest User Tries to Save
  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Sign In Required"),
          content: Text("You must be signed in to save trials."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                GoRouter.of(context).go('/login'); // Redirect to login
              },
              style: TextButton.styleFrom(foregroundColor: Colors.teal),
              child: Text("Sign In"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final studyDetails = widget.study.protocolSection;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trial Details'),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// **🔹 Study Contact Info**
            Row(
              children: [
                CustomAvatar(),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        studyDetails?.contactsLocationsModule?.overallOfficials
                                ?.first.name ??
                            'Official name not available',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        studyDetails?.contactsLocationsModule?.overallOfficials
                                ?.first.role
                                ?.replaceAll(RegExp('_'), ' ') ??
                            'Role not available',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        studyDetails?.contactsLocationsModule?.locations?.first
                                .facility ??
                            'Location not available',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Divider(
                color: Colors.grey, thickness: 1, indent: 30, endIndent: 30),

            /// **🔹 Study Title**
            Text(
              studyDetails?.identificationModule?.briefTitle ??
                  "Title not available",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Divider(
                color: Colors.grey, thickness: 1, indent: 30, endIndent: 30),

            /// **🔹 Study Description**
            Text(
              studyDetails
                      ?.outcomesModule?.primaryOutcomes?.first.description ??
                  "Description not available",
            ),

            SizedBox(height: 16),

            /// **🔹 Save Button (Disabled for Guests)**
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _toggleSave(context),
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                label: Text(user == null
                    ? "Log in to Save"
                    : (isSaved ? "Unsave Trial" : "Save Trial")),
                style: ElevatedButton.styleFrom(
                  backgroundColor: user == null
                      ? Colors.grey
                      : Colors.teal, // Disable for guests
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
