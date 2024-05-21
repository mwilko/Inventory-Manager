import 'package:flutter/material.dart';
import '../../components/theme_notifier.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget { // HomeAppBar class to create the app bar for the home page
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ThemeNotifier themeNotifier;

  HomeAppBar({ // HomeAppBar constructor
    required this.scaffoldKey,
    required this.themeNotifier,
  });

  @override
  Widget build(BuildContext context) { // Build the app bar
    return AppBar(
      leading: IconButton( // Add a leading icon button to open the drawer
        icon: Icon(Icons.menu),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton( // Add a button to toggle the theme
          icon: Icon(themeNotifier.isDarkMode ? Icons.brightness_7 : Icons.brightness_2),
          onPressed: () {
            themeNotifier.toggleTheme();
            themeNotifier.savePreferences();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
