import 'package:capybara/routing/app_router.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/firestore_service.dart';

class SavedTrialsScreen extends ConsumerWidget {
  const SavedTrialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade100,
        title:
            const Text("Saved Trials", style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<List<Studies>>(
        stream: firestoreService.getSavedTrials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No saved trials found."));
          }

          final savedTrials = snapshot.data!;

          return ListView.builder(
            itemCount: savedTrials.length,
            itemBuilder: (context, index) {
              final trial = savedTrials[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black26, width: 1),
                ),
                child: ListTile(
                  title: Text(
                    trial.protocolSection?.identificationModule?.briefTitle ??
                        "No Title Available",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    trial.protocolSection?.identificationModule
                            ?.officialTitle ??
                        "No Official Title",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      firestoreService.removeTrial(
                        trial.protocolSection?.identificationModule?.nctId ??
                            "",
                      );
                    },
                  ),
                  onTap: () {
                    context.pushNamed(
                      AppRoute.details.name,
                      extra: trial, // Pass study object
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
