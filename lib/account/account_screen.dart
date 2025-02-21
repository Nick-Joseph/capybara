import 'package:capybara/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // Link to your donation page (e.g., BuyMeACoffee, PayPal, etc.)
  final String donationLink = 'https://buymeacoffee.com/njoseph3215';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("My Account",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16), // Removed the profile picture
              Text(
                user?.email ?? "No email found",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    context.goNamed(
                        AppRoute.signIn.name); // Redirect to login screen
                  },
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.coffee),
                    label: const Text(
                      "Buy the Dev a Coffee",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: () async {
                      // Launch the donation link
                      Uri donationUri = Uri.parse(donationLink);

                      if (await canLaunchUrl(donationUri)) {
                        await launchUrl(
                          donationUri,
                          mode: LaunchMode
                              .inAppBrowserView, // Opens in Safari/Chrome
                        );
                      } else {
                        throw 'Could not launch $donationUri';
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
