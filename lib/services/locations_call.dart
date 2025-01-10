// import 'dart:convert';

// import 'package:flutter/material.dart';

// class LocationsCall extends StatelessWidget {
//   final String jsonString = '''
//   {
//     "protocolSection": {
//       "contactsLocationsModule": {
//         "locations": [
//           {
//             "name": "Location A",
//             "city": "Orlando",
//             "state": "Florida"
//           },
//           {
//             "name": "Location B",
//             "city": "Miami",
//             "state": "Florida"
//           }
//         ]
//       }
//     }
//   }
//   ''';

//   const LocationsCall({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final jsonData = jsonDecode(jsonString);
//     final locations = jsonData['protocolSection']['contactsLocationsModule']
//         ['locations'] as List?;

//     if (locations == null || locations.isEmpty) {
//       return Center(child: Text('No locations available'));
//     }

//     return ListView.builder(
//       itemCount: locations.length,
//       itemBuilder: (context, index) {
//         final location = locations[index];
//         final name = location['name'] ?? 'Unknown Name';
//         final city = location['city'] ?? 'Unknown City';
//         final state = location['state'] ?? 'Unknown State';

//         return ListTile(
//           title: Text(name),
//           subtitle: Text('$city, $state'),
//         );
//       },
//     );
//   }
// }
