import 'package:flutter/material.dart';
import '../add_inventory.dart';
import '../inventory_location.dart';
import '../move_inventory.dart';
import '../profile.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  @override
  Widget build(BuildContext context) { // Update the UI to display user
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.2,
      backgroundColor: Colors.grey[300],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text( // Display the sidebar title
              'Sidebar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          IconButton( // Inventory Location button
            icon: Icon(Icons.pallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryLocation()),
              );
            },
            tooltip: 'Inventory Location',
            color: Colors.black,
          ),
          IconButton( // Move Inventory button
            icon: Icon(Icons.forklift),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoveInventory()),
              );
            },
            tooltip: 'Move Inventory',
            color: Colors.black,
          ),
          IconButton( // Add Inventory button
            icon: Icon(Icons.add_box),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddInventory()),
              );
            },
            tooltip: 'Add Inventory',
            color: Colors.black,
          ),
          IconButton( // Profile button
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            tooltip: 'Profile',
            color: Colors.black,
          ),
        ],
      ),
    );  
  }
}
