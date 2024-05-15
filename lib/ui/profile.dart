import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, String>> _usernameFuture; // Update the type to match the return type of _initializePrefs()

  @override
  void initState() {
    super.initState();
    _usernameFuture = _initializePrefs(); // Assign the Future<Map<String, String>> to _usernameFuture
  }

  // Function to initialize SharedPreferences and retrieve the username
  Future<Map<String, String>> _initializePrefs() async { // Change the return type to Future<Map<String, String>>
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    String? username = prefs.getString('username'); // Retrieve the username from SharedPreferences
    String? email = prefs.getString('email'); // Retrieve the email from SharedPreferences
    return {'username': username ?? '', 'email': email ?? ''}; // Return both username and email
  }

  // Function to log out
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Remove username from SharedPreferences
    await prefs.remove('email'); // Remove email from SharedPreferences
    await prefs.remove('token'); // Remove token from SharedPreferences
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) { // Update the UI to display user
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
      body: Column(
        children: [
          Center(
            child: FutureBuilder<Map<String, String>>( // Update FutureBuilder to use Map<String, String>
              future: _usernameFuture, // Use the Future holding the username
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for SharedPreferences initialization
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Display an error message if SharedPreferences initialization fails
                  } else {
                    String? username = snapshot.data?['username']; // Retrieve the username from the snapshot map
                    String? email = snapshot.data?['email']; // Retrieve the email from the snapshot map
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 28,
                          child: Text(
                            username?.substring(0, 1).capitalized ?? '', // Display the first letter of the username as the avatar
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text( // Display the username
                          username ?? 'Unknown', // Display the username
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text( // Display a welcome message
                          'Welcome to your profile!',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                  child: Column(
                                  children: [
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Username:'),
                                      Text(username ?? 'Unknown'), // Display the username
                                    ],
                                    ),
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Email:'),
                                      Text(email ?? 'Unknown'), // Display the email
                                    ],
                                    ),
                                  ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
