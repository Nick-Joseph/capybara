import 'package:capybara/services/get_clinical_trails_api.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Studies>> futureStudies;
  @override
  void initState() {
    super.initState();
    futureStudies = fetchStudies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Studies>>(
        future: futureStudies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is loading, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display it
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the data is empty, display a message
            return Center(child: Text('No studies found.'));
          } else {
            // Once data is loaded, display it in a ListView
            final studies = snapshot.data!;
            return ListView.builder(
              itemCount: studies.length,
              itemBuilder: (context, index) {
                final study = studies[index];
                return ListTile(
                  title: Text(
                    study.protocolSection?.identificationModule?.nctId ?? '',
                  ),
                  subtitle: Text(study.protocolSection?.identificationModule
                      ?.briefTitle as String),
                  onTap: () {
                    context.go('/details', extra: study);
                    // Handle tap if needed, e.g., navigate to a detail page
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
