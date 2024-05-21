import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget { // Profile page
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> { // State class for the profile page
  late Future<Map<String, String>> _userDataFuture;

  @override
  void initState() { // Initialize the state
    super.initState();
    _userDataFuture = _initializeUserData();
  }

  Future<Map<String, String>> _initializeUserData() async { // Function to initialize the user data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    return {'username': username ?? '', 'email': email ?? ''};
  }

  Future<void> _logout() async { // Function to log out the user
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the profile page
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          //// TODO: Fix logout bug. When user logs out and tries to login again, the program crashes.
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: _logout,
          // ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) { // Check if the connection state is waiting
              return CircularProgressIndicator();
            } else { // Check if the connection state is not waiting
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
                } else {
                String? username = snapshot.data?['username'];
                String? email = snapshot.data?['email'];
                return Column( // Display user profile information
                  mainAxisAlignment: MainAxisAlignment.start, // Move column to the top of the screen
                  children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                    username?.substring(0, 1).capitalized ?? '',
                    style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text( // Display the username
                    username ?? 'Unknown',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text( // Display the welcome message
                    'Welcome to your profile!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),
                  Padding( 
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                      Row( // Display the username
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Username:', style: TextStyle(color: Colors.black)),
                        Text(username ?? 'Unknown', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      Row( // Display the email
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Email:', style: TextStyle(color: Colors.black)),
                        Text(email ?? 'Unknown', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      ],
                    ),
                    ),
                  ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
