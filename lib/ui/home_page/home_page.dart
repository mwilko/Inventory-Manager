import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventory_manager/controllers/menu_app_controller.dart';
import 'package:inventory_manager/ui/home_page/home_components/home_page_body.dart';
import 'package:provider/provider.dart';
import 'home_components/sidebar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/theme_notifier.dart';
import 'home_components/home_appbar.dart';

class HomePage extends StatefulWidget { // HomePage widget to display the main content of the app
  final String token;

  const HomePage({required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver { // HomePageState widget to display the main content of the app
  late String userId;
  late Future<Map<String, dynamic>> _prefsFuture;

  @override
  void initState() { // Initialize the state
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('HomePage initState called.');

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    print('Token decoded: $jwtDecodedToken');

    userId = jwtDecodedToken['_id'];
    _prefsFuture = _initializePrefs();
    print('User ID: $userId');
  }

  Future<Map<String, dynamic>> _initializePrefs() async { // Function to initialize the user preferences
    print('Initializing preferences...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    print('Username retrieved: $username');
    return {'username': username ?? ''};
  }

  @override
  void dispose() { // Dispose the state
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { // Handle app lifecycle state changes
    print('App lifecycle state changed to: $state');
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the home page
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    MenuAppController menuAppController = Provider.of<MenuAppController>(context);

    print('Building HomePage...');
    return Scaffold(
      key: menuAppController.scaffoldKey,
      appBar: HomeAppBar( // Display the app bar
        themeNotifier: themeNotifier, 
        scaffoldKey: menuAppController.scaffoldKey,
      ),
      drawer: Sidebar(), // Display the sidebar
      body: HomePageBody(
        userId: userId,
        prefsFuture: _prefsFuture
      ), // Display the main content of the app
    );
  }
}
