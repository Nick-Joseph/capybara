import 'package:capybara/services/firestore_service.dart';
import 'package:capybara/services/study_class.dart';
import 'package:capybara/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class StudyDetailPage extends StatelessWidget {
  final Studies study;
  final FirestoreService firestoreService = FirestoreService();
  StudyDetailPage({super.key, required this.study});
  void _saveTrial(BuildContext context) async {
    await firestoreService.saveTrial(study);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved to your trials!")),
    );
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
                          (study.protocolSection?.contactsLocationsModule
                                      ?.overallOfficials?.first.name !=
                                  null)
                              ? Text(study
                                  .protocolSection!
                                  .contactsLocationsModule!
                                  .overallOfficials!
                                  .first
                                  .name!)
                              : Text('Officals name not available'),
                          (study.protocolSection?.contactsLocationsModule
                                      ?.overallOfficials?.first.role !=
                                  null)
                              ? Text(study
                                  .protocolSection!
                                  .contactsLocationsModule!
                                  .overallOfficials!
                                  .first
                                  .role!
                                  .replaceAll(RegExp('_'), ' '))
                              : Text('Role not available'),
                          (study.protocolSection?.contactsLocationsModule
                                      ?.locations?.first.facility !=
                                  null)
                              ? Text(study
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
                  study.protocolSection?.identificationModule?.briefTitle
                      as String,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                ),
                (study.protocolSection?.outcomesModule?.primaryOutcomes?.first
                            .description !=
                        null)
                    ? Text(study.protocolSection!.outcomesModule!
                        .primaryOutcomes?.first.description as String)
                    : (Text('Description not available')),
                ElevatedButton.icon(
                  onPressed: () => _saveTrial(context),
                  icon: Icon(Icons.save),
                  label: Text("Save Trial"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
