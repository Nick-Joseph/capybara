import 'package:capybara/services/get_clinical_trails_api.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Studies> studies = [];

  void _performSearch() {
    setState(() {
      studies = []; // Clear previous studies
    });

    fetchStudiesFromApi(query: _searchController.text);
  }

  Future<void> fetchStudiesFromApi({String? query}) async {
    try {
      // Ensure the correct function fetches the studies based on query
      final result = await fetchStudies1(query: query);

      // Update state with the fetched studies
      setState(() {
        studies = result?.studies ?? []; // Safely update the list
      });
    } catch (e) {
      print('Error fetching studies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search clinical trials...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
      body: studies.isEmpty
          ? Center(child: Text('No studies found.'))
          : ListView.builder(
              itemCount: studies.length,
              itemBuilder: (context, index) {
                final study = studies[index];
                return Card(
                  child: ListTile(
                    title: Text(study.protocolSection?.identificationModule
                            ?.briefTitle ??
                        'No Brief Title'),
                    subtitle: Text(study.protocolSection?.identificationModule
                            ?.officialTitle ??
                        'No Official Title'),
                  ),
                );
              },
            ),
    );
  }
}
