import 'package:flutter/material.dart';
import '../add_inventory.dart';
import '../inventory_location.dart';
import '../move_inventory.dart';
import '../profile.dart';

class Sidebar extends StatefulWidget { // Sidebar widget to display the sidebar menu
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> { // SidebarState widget to manage the sidebar menu
  @override
  Widget build(BuildContext context) { // Build the UI for the sidebar menu
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Colors.grey[300],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                color: Color.fromARGB(242, 31, 24, 30), // Alpha value and RGB to match logo
                ),
              child: Image.asset('images/logo-banner-style.png'), // Remove the child widget
            ),
          // Inventory Location button
          TextButton.icon( // Add a button to navigate to the Inventory Location page
            icon: Padding( // Add an icon to the button
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.pallet,
                color: Colors.black,
              ),
            ),
            label: Text( // Add a label to the button
              'Inventory Location',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push( // Navigate to the Inventory Location page
                context,
                MaterialPageRoute(builder: (context) => InventoryLocation()),
              );
            },
            style: ButtonStyle( // Add styling to the button
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 48),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          // Move Inventory button
          TextButton.icon( // Add a button to navigate to the Move Inventory page
            icon: Padding( // Add an icon to the button
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.forklift,
                color: Colors.black,
              ),
            ),
            label: Text( // Add a label to the button
              'Move Inventory',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push( // Navigate to the Move Inventory page
                context,
                MaterialPageRoute(builder: (context) => MoveInventory()),
              );
            },
            style: ButtonStyle( // Add styling to the button
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 48),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          // Add Inventory button
          TextButton.icon( // Add a button to navigate to the Add Inventory page
            icon: Padding( // Add an icon to the button
              padding: const EdgeInsets.only(left: 8.0), 
              child: Icon(
                Icons.add_box,
                color: Colors.black,
              ),
            ),
            label: Text( // Add a label to the button
              'Add Inventory',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.push( // Navigate to the Add Inventory page
                context,
                MaterialPageRoute(builder: (context) => AddInventory()),
              );
            },
            style: ButtonStyle( // Add styling to the button
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 48),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          // Profile button
          TextButton.icon( // Add a button to navigate to the Profile page
            icon: Padding( // Add an icon to the button
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            label: Text( // Add a label to the button
              'Profile',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () { // Navigate to the Profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            style: ButtonStyle( // Add styling to the button
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 48),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}
