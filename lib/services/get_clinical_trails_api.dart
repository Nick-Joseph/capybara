import 'dart:convert';

import 'package:capybara/services/study_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final url = Uri.parse('https://clinicaltrials.gov/api/v2/studies');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Response data: ${response.body}');
    } else {
      // If the server returns an error, throw an exception.
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // If an error occurs, print the error message.
    print('Error: $e');
  }
}

// Function to fetch studies from the API
Future<List<Studies>> fetchStudies() async {
  final response = await http.get(
    Uri.parse('https://clinicaltrials.gov/api/v2/studies'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    List<dynamic> studyList = data['studies'];
    final List<Studies> studies =
        studyList.map((json) => Studies.fromJson(json)).toList();
    return studies;
  } else {
    throw Exception('Failed to load studies');
  }
}
