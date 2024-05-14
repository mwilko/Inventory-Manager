import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InventoryLocation extends StatefulWidget {
  @override
  _InventoryLocationState createState() => _InventoryLocationState();
}

class _InventoryLocationState extends State<InventoryLocation> {
  TextEditingController _locationController = TextEditingController();

  Future<void> _searchInventory(String location) async { // A function to search the inventory based on the location.
    final response = await http.get(Uri.parse('http://localhost:3000/products?location=$location')); // Send a GET request to the API
    if (response.statusCode == 200) { // If the response is successful
      print(response.body);
    } else { // If the response is not successful
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the InventoryLocation widget.
    return Scaffold( 
      appBar: AppBar( // Create an AppBar for the InventoryLocation widget.
        title: Text('Inventory Management'),
      ),
      body: Column( // Create a Column widget to display the UI elements.
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration( // Create a TextField widget to get the location input from the user.
                labelText: 'Enter Location Filter',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchInventory(_locationController.text);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
