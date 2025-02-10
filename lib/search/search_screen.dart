import 'package:capybara/services/get_clinical_trails_api.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  String? nextPageToken;
  bool isLoading = false;
  List<Studies> studies = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchInitialStudies();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more studies when the user reaches the bottom
      if (nextPageToken != null && !isLoading) {
        fetchMoreStudies();
      }
    }
  }

  Future<void> fetchInitialStudies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await fetchStudies(pageToken: null);
      setState(() {
        studies = result.studies ?? [];
        nextPageToken =
            result.nextPageToken; // Store the nextPageToken from the response
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching studies: $e');
    }
  }

  Future<void> fetchMoreStudies() async {
    if (nextPageToken == null || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await fetchStudies(pageToken: nextPageToken);
      setState(() {
        studies.addAll(result.studies ?? []);
        nextPageToken = result.nextPageToken;
        isLoading = false;
      });

      // Show Snackbar after fetching more data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('More studies have been loaded!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching more studies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: studies.isEmpty && !isLoading
            ? Center(child: Text('No studies found.'))
            : ListView.builder(
                controller: _scrollController,
                itemCount: studies.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == studies.length) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Show loading spinner at the bottom
                  }

                  final study = studies[index];
                  return Card(
                    color: Colors.red.shade100,
                    child: ListTile(
                      title: Text(study.protocolSection?.identificationModule
                              ?.briefTitle ??
                          ''),
                      subtitle: Text(study.protocolSection?.identificationModule
                              ?.officialTitle ??
                          ''),
                      onTap: () {
                        context.go('/details', extra: study);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
