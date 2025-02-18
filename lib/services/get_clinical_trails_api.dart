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

Future<Study> fetchStudiesFromApi({
  String? query,
}) async {
  final Map<String, String> params = {
    'pageSize': '20', // Limit results per request
    if (query != null && query.isNotEmpty)
      'search': query, // Use 'search' for the query
  };

  final Uri apiUrl = Uri.https('clinicaltrials.gov', '/api/v2/studies', params);

  print("Fetching: $apiUrl"); // Debug URL in console

  final response = await http.get(apiUrl, headers: {
    "Accept": "application/json",
  });

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return Study.fromJson(json.decode(response.body));
  } else {
    print('Error response: ${response.body}'); // Log the error response
    throw Exception('Failed to load studies');
  }
}

Future<Study?> fetchStudies1({String? query}) async {
  final Map<String, String> params = {
    'pageSize': '10', // Limit the number of results
    if (query != null && query.isNotEmpty)
      'query.cond': query, // Use 'term' to search for studies
  };

  Uri uri = Uri.https('clinicaltrials.gov', '/api/v2/studies', params);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    List<dynamic> studyList = data['studies'];
    final List<Studies> studies =
        studyList.map((json) => Studies.fromJson(json)).toList();

    return Study(studies: studies);
  } else {
    print('Error response: ${response.body}'); // Log the error response
    throw Exception('Failed to load studies');
  }
}
