import 'package:capybara/services/firestore_service.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/widgets/profile_avatar.dart';
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

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  /// Check if the study is saved in Firestore
  void _checkIfSaved() async {
    bool saved = await firestoreService.isTrialSaved(
        widget.study.protocolSection!.identificationModule!.nctId!);
    setState(() {
      isSaved = saved;
    });
  }

  /// Save or Unsave the study
  void _toggleSave(BuildContext context) async {
    if (isSaved) {
      await firestoreService.removeTrial(
          widget.study.protocolSection!.identificationModule!.nctId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Removed from your trials!"),
        ),
      );
    } else {
      await firestoreService.saveTrial(widget.study);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Saved to your trials!"),
        ),
      );
    }

    // Update UI
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomAvatar(),
                    Expanded(
                      child: Column(
                        children: [
                          (widget.study.protocolSection?.contactsLocationsModule
                                      ?.overallOfficials?.first.name !=
                                  null)
                              ? Text(widget
                                  .study
                                  .protocolSection!
                                  .contactsLocationsModule!
                                  .overallOfficials!
                                  .first
                                  .name!)
                              : Text('Official name not available'),
                          (widget.study.protocolSection?.contactsLocationsModule
                                      ?.overallOfficials?.first.role !=
                                  null)
                              ? Text(widget
                                  .study
                                  .protocolSection!
                                  .contactsLocationsModule!
                                  .overallOfficials!
                                  .first
                                  .role!
                                  .replaceAll(RegExp('_'), ' '))
                              : Text('Role not available'),
                          (widget.study.protocolSection?.contactsLocationsModule
                                      ?.locations?.first.facility !=
                                  null)
                              ? Text(widget
                                  .study
                                  .protocolSection!
                                  .contactsLocationsModule!
                                  .locations!
                                  .first
                                  .facility!)
                              : Text('Location not available'),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                ),
                Text(
                  widget.study.protocolSection?.identificationModule?.briefTitle
                      as String,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                ),
                (widget.study.protocolSection?.outcomesModule?.primaryOutcomes
                            ?.first.description !=
                        null)
                    ? Text(widget.study.protocolSection!.outcomesModule!
                        .primaryOutcomes?.first.description as String)
                    : (Text('Description not available')),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _toggleSave(context);
                    context.pop();
                  },
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(isSaved ? "Unsave Trial" : "Save Trial"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
