import 'package:flutter/material.dart';
import 'ui/dashboard.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter app is initialized
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
  runApp(MyApp(token: prefs.getString('token'))); // if the user has logged in recently, the token will be stored in the SharedPreferences
}

class MyApp extends StatelessWidget {
  final token;

  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { // Build the main application widget
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle the case where the route parameter is null
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => SignInPage());
        }
        // You can add more route handling logic here if needed
        return null; // Return null if the route is not handled
      },
      home: (token != null && !JwtDecoder.isExpired(token)) // if its null (username), let it pass
          ? Dashboard(token: token)
          : SignInPage(),
      // Add additional routes here
    );
  }
}
