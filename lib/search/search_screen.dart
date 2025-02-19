import 'package:capybara/routing/app_router.dart';
import 'package:capybara/services/get_clinical_trails_api.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

  void _performSearch() {
    setState(() {
      studies = []; // Clear previous results
      nextPageToken = null; // Reset pagination
    });

    fetchStudiesFromApi(query: _searchController.text);
  }

  Future<void> fetchStudiesFromApi({String? query}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await fetchSearchStudies(query: query, pageToken: null);

      setState(() {
        studies = result?.studies ?? [];
        nextPageToken = result?.nextPageToken;
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
      final result = await fetchSearchStudies(
          query: _searchController.text, pageToken: nextPageToken);

      setState(() {
        studies.addAll(result?.studies ?? []);
        nextPageToken = result?.nextPageToken;
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
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
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
        body: studies.isEmpty && isLoading
            ? _buildShimmerList() // Show shimmer when initially loading
            : ListView.builder(
                controller: _scrollController,
                itemCount: studies.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == studies.length) {
                    return _buildShimmerCard(); // Show shimmer at the bottom
                  }

                  final study = studies[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.white,
                      elevation: 5.0,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          study.protocolSection?.identificationModule
                                  ?.briefTitle ??
                              'No Brief Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          study.protocolSection?.identificationModule
                                  ?.officialTitle ??
                              'No Official Title',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          context.pushNamed(
                            AppRoute.details.name,
                            extra: study, // Pass the study object
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  /// Builds a full-page shimmer list to mimic the study cards
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Show 5 shimmer cards initially
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  /// Builds a single shimmer card that matches the study UI
  Widget _buildShimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ), // Title Placeholder
                SizedBox(height: 10.0),
                Container(
                  width: 150.0,
                  height: 15.0,
                  color: Colors.white,
                ), // Subtitle Placeholder
                SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  color: Colors.white,
                ), // Description Placeholder
              ],
            ),
          ),
        ),
      ),
    );
  }
}
