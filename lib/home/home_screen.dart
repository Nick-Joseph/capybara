import 'package:capybara/routing/app_router.dart';
import 'package:capybara/services/get_clinical_trails_api.dart';
import 'package:capybara/services/study_class.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // App bar color
        elevation: 0.0,
        title: Text(
          'Clinical Trials',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                return _buildStudyCard(study);
              },
            ),
    );
  }

  // Builds the shimmer list for the initial loading screen
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Show 10 shimmer cards initially
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  // Builds a shimmer card for loading state
  Widget _buildShimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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

  // Builds a study card
  Widget _buildStudyCard(Studies study) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        elevation: 5.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            study.protocolSection?.identificationModule?.briefTitle ??
                'No Brief Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            study.protocolSection?.identificationModule?.officialTitle ??
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
  }
}
