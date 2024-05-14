import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? prefs;
  String? username;

  @override
  void initState() {
    super.initState();
    initializePrefs(); // Call the function to initialize SharedPreferences
  }

  // Function to initialize SharedPreferences
  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    // Retrieve the username from SharedPreferences
    username = prefs?.getString('username'); 
  }

  // Function to log out
  Future<void> logout() async {
    await prefs?.remove('username'); // Remove username from SharedPreferences
    await prefs?.remove('token'); // Remove token from SharedPreferences
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
            onPressed: logout, // Call logout function when logout button is pressed
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Username: $username'), // Display the username
          ),
        ],
      ),
    );
  }
}
