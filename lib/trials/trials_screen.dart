import 'package:capybara/routing/app_router.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/firestore_service.dart';
import 'package:shimmer/shimmer.dart';

class SavedTrialsScreen extends ConsumerWidget {
  const SavedTrialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // More neutral teal color for AppBar
        title: const Text("Saved Trials",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<Studies>>(
        stream: firestoreService.getSavedTrials(), // Using Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList(); // Show shimmer while waiting for data
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No saved trials found.",
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            );
          }

          final savedTrials = snapshot.data!;

          return ListView.builder(
            itemCount: savedTrials.length,
            itemBuilder: (context, index) {
              final trial = savedTrials[index];

              return _buildSavedTrialCard(trial, firestoreService, context);
            },
          );
        },
      ),
    );
  }

  // Shimmer effect for loading
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Show 5 shimmer cards
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  // Shimmer card to mimic loading
  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    height: 20.0,
                    color: Colors.white), // Title Placeholder
                const SizedBox(height: 10.0),
                Container(
                    width: 150.0,
                    height: 15.0,
                    color: Colors.white), // Subtitle Placeholder
                const SizedBox(height: 10.0),
                Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.white), // Description Placeholder
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the actual saved trial card
  Widget _buildSavedTrialCard(
      Studies trial, FirestoreService firestoreService, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0, // Added shadow to make the card stand out
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            trial.protocolSection?.identificationModule?.briefTitle ??
                "No Title Available",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            trial.protocolSection?.identificationModule?.officialTitle ??
                "No Official Title",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              firestoreService.removeTrial(
                trial.protocolSection?.identificationModule?.nctId ?? "",
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trial removed successfully.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          onTap: () {
            context.pushNamed(
              AppRoute.details.name,
              extra: trial, // Pass study object to details screen
            );
          },
        ),
      ),
    );
  }
}
