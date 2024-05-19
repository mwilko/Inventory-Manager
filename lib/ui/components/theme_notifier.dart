import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier { // ThemeNotifier class to toggle between light and dark mode
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() { // Function to toggle between light and dark mode
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void loadPreferences() async { // Function to load the user preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  void savePreferences() async { // Function to save the user preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
  }
}
