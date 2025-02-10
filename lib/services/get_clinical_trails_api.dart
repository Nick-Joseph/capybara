import 'dart:convert';

import 'package:capybara/services/study_class.dart';

import 'package:http/http.dart' as http;

Future<Study> fetchStudies({
  String? pageToken,
  int pageSize = 10,
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
