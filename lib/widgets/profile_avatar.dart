import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 30, // Adjust the radius as needed
        // Replace with your image path
        // If no image, use a background color instead:
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person,
            size: 50, color: Colors.white), // Placeholder icon
      ),
    );
  }
}
