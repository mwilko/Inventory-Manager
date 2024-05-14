import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<String?> _usernameFuture; // Future to hold the username

  @override
  void initState() {
    super.initState();
    _usernameFuture = _initializePrefs(); // Initialize SharedPreferences and retrieve the username
  }

  // Function to initialize SharedPreferences and retrieve the username
  Future<String?> _initializePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    return prefs.getString('username'); // Retrieve the username
  }

  // Function to log out
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Remove username from SharedPreferences
    await prefs.remove('token'); // Remove token from SharedPreferences
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Call logout function when logout button is pressed
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _usernameFuture, // Use the Future holding the username
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for SharedPreferences initialization
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Display an error message if SharedPreferences initialization fails
            } else {
              String? username = snapshot.data; // Retrieve the username from the snapshot
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Username: ${username ?? "Unknown"}'), // Display the username or a default value if it's null
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
