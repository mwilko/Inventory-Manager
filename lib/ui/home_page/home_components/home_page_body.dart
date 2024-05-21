import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget { // HomePageBody class to display the user ID and username
  final String userId;
  final Future<Map<String, dynamic>> prefsFuture;

  HomePageBody({
    required this.userId,
    required this.prefsFuture,
  });

  @override
  Widget build(BuildContext context) { // Build the UI of the HomePageBody widget
    return FutureBuilder<Map<String, dynamic>>(
      future: prefsFuture, // Future to get the user preferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          String username = snapshot.data?['username'] ?? 'Unknown';
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 75.0, top: 16.0, bottom: 16),
                  child: Text( // Display the welcome message
                    'Welcome, $username! \u{1F44B}',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding( // Display the user ID
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'User ID: $userId',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
        } else { // Show a message if no preferences are found
          return Center(child: Text('No preferences found.'));
        }
      },
    );
  }
}
