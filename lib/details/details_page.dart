import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';

class StudyDetailPage extends StatelessWidget {
  final Studies study;

  const StudyDetailPage({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    // Replace with your data fetching logic

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: (study.protocolSection?.contactsLocationsModule
                              ?.locations !=
                          null)
                      ? Text(study.protocolSection!.contactsLocationsModule!
                          .locations!.first.facility!)
                      : Text('Locations not available'),
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
              ],
            ),
          ),

          // Text(study.description),
          // Add more study details here
        ),
      ),
    );
  }
}
