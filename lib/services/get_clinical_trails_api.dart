import 'dart:convert';

import 'package:capybara/services/study_class.dart';

import 'package:http/http.dart' as http;

Future<Study> fetchStudies({
  String? pageToken,
  int pageSize = 10,
  String? query,
}) async {
  final Map<String, String> params = {
    'pageSize': pageSize.toString(),
    if (pageToken != null)
      'pageToken': pageToken, // Only include pageToken if it's provided
  };

  Uri uri = Uri.https('clinicaltrials.gov', '/api/v2/studies', params);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Ensure that nextPageToken exists in the response
    String? nextPageToken = data['nextPageToken'];

    print('Fetched nextPageToken: $nextPageToken'); // Debugging log

    List<dynamic> studyList = data['studies'];
    final List<Studies> studies =
        studyList.map((json) => Studies.fromJson(json)).toList();

    return Study(studies: studies, nextPageToken: nextPageToken);
  } else {
    throw Exception('Failed to load studies');
  }
}

Future<Study?> fetchSearchStudies({
  String? query,
  int pageSize = 20,
  String? pageToken,
}) async {
  final Map<String, String> params = {
    'pageSize': pageSize.toString(), // Limit the number of results
    if (query != null && query.isNotEmpty)
      'query.cond': query, // Use query if available
    if (pageToken != null)
      'pageToken': pageToken, // Include the pageToken if available
  };

  Uri uri = Uri.https('clinicaltrials.gov', '/api/v2/studies', params);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Decode the list of studies
    List<dynamic> studyList = data['studies'];
    final List<Studies> studies =
        studyList.map((json) => Studies.fromJson(json)).toList();

    // Fetch the nextPageToken for pagination
    final String? nextPageToken = data['nextPageToken'];

    // Return the studies and the nextPageToken to be used for the next fetch
    return Study(studies: studies, nextPageToken: nextPageToken);
  } else {
    print('Error response: ${response.body}'); // Log the error response
    throw Exception('Failed to load studies');
  }
}
