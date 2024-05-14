import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? prefs;
  String? username;
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializePrefs();
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs?.getString('username');
  }

  Future<void> _displayProfileSettings() async {
    final location = _locationController.text;
    final response = await http.get(Uri.parse('http://localhost:3000/products?location=$location'));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location Filter',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _displayProfileSettings();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}