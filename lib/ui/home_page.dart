import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/sidebar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/theme_notifier.dart';

class HomePage extends StatefulWidget { // Home page
  final String token;

  const HomePage({required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { // State class for the home page
  late String userId;
  late Future<Map<String, dynamic>> _prefsFuture;

  @override
  void initState() { // Initialize the state
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    _prefsFuture = _initializePrefs();
  }

  Future<Map<String, dynamic>> _initializePrefs() async { // Initialize shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return {'username': username ?? ''};
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a global key for the scaffold

  @override
  Widget build(BuildContext context) { // Build the home page
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [ // Add a button to toggle dark mode
          IconButton(
            icon: Icon(themeNotifier.isDarkMode ? Icons.brightness_7 : Icons.brightness_2),
            onPressed: () {
              themeNotifier.toggleTheme();
              themeNotifier.savePreferences();
            },
          ),
        ],
      ),
      drawer: Sidebar(), // Add the sidebar menu
      body: FutureBuilder<Map<String, dynamic>>(// Add a future builder to get the user details
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String username = snapshot.data?['username'] ?? 'Unknown';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 75.0, top: 16.0, bottom: 16),
                  child: Text(
                    'Welcome, $username! \u{1F44B}',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
