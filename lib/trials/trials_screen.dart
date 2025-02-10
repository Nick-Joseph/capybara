import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

class SavedTrialsScreen extends ConsumerWidget {
  const SavedTrialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red.shade100,
          title: Text("Saved Trials", style: TextStyle(color: Colors.black))),
      body: StreamBuilder<List<Studies>>(
        stream: firestoreService.getSavedTrials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No saved trials found."));
          }

          final savedTrials = snapshot.data!;

          return ListView.builder(
            itemCount: savedTrials.length,
            itemBuilder: (context, index) {
              final trial = savedTrials[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black26, width: 1),
                ),
                child: ListTile(
                  title: Text(
                      trial.protocolSection?.identificationModule?.briefTitle
                          as String,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(trial.protocolSection?.identificationModule
                      ?.officialTitle as String),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      firestoreService.removeTrial(trial.protocolSection!
                          .identificationModule!.nctId as String);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
