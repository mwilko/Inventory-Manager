import 'package:flutter/material.dart';

class LightDarkMode extends StatelessWidget { // LightDarkMode widget to toggle between light and dark mode
  final bool isDarkMode;
  final Function toggleTheme;

  LightDarkMode({
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) { // Build the UI of the LightDarkMode widget
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text( // Display the text 'Dark Mode'
          'Dark Mode',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Switch( // Add a switch to toggle between light and dark mode
          value: isDarkMode,
          onChanged: (value) {
            toggleTheme();
          },
          activeColor: Colors.black,
          activeTrackColor: Colors.grey,
        ),
      ],
    );
  }
}