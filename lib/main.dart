import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/core_pages/login_page.dart';
import 'ui/components/theme_notifier.dart';
import 'controllers/menu_app_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter binding is initialized
  runApp(MyApp()); // Run the app
}

class MyApp extends StatelessWidget { // MyApp widget to create the app
  @override
  Widget build(BuildContext context) { // Build the app
    return MultiProvider( // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) {
            ThemeNotifier themeNotifier = ThemeNotifier();
            themeNotifier.loadPreferences();
            return themeNotifier;
          },
        ),
        ChangeNotifierProvider<MenuAppController>(
          create: (_) => MenuAppController(),
        ),
      ],
      child:Consumer<ThemeNotifier>( // Use Consumer to consume the ThemeNotifier provider
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Inventory Manager',
            debugShowCheckedModeBanner: false,
            theme: ThemeData( 
              fontFamily: 'Manrope', // Set the default font family
              brightness: Brightness.light, // Set the default brightness to light
            ),
            darkTheme: ThemeData(
              fontFamily: 'Manrope', // Set the default font family
              brightness: Brightness.dark, // Set the default brightness to dark
            ),
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/login', // Always start at the login page
            routes: {
              '/login': (_) => SignInPage(),
              // Add other routes as needed
            },
          );
        },
      ),
    );
  }
}
