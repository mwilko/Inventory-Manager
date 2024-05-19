// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home_page.dart';
import 'ui/login_page.dart';
import 'ui/components/theme_notifier.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async { // Main function
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget { // Main app widget
  final String? token;

  const MyApp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { // Build the main app
    return ChangeNotifierProvider( // Use the change notifier provider to toggle between light and dark mode
      create: (_) {
        ThemeNotifier themeNotifier = ThemeNotifier();
        themeNotifier.loadPreferences();
        return themeNotifier;
      },
      child: Consumer<ThemeNotifier>( // Use the theme notifier to toggle between light and dark mode
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Inventory Manager',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            onGenerateRoute: (settings) { // Generate routes for the app
              if (settings.name == '/login') {
                return MaterialPageRoute(builder: (_) => SignInPage());
              }
              return null;
            },
            home: (token != null && !JwtDecoder.isExpired(token!)) // Check if the token is not null and not expired
                ? HomePage(token: token!)
                : SignInPage(),
          );
        },
      ),
    );
  }
}
