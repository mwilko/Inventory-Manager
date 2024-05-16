import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/config.dart';

class MoveInventory extends StatelessWidget { // MoveInventory widget to move inventory
  @override
  Widget build(BuildContext context) {
    return _MoveInventoryForm();
  }
}

class _MoveInventoryForm extends StatefulWidget { // MoveInventoryForm widget to move inventory
  @override
  _MoveInventoryState createState() => _MoveInventoryState();
}

class _MoveInventoryState extends State<_MoveInventoryForm> { // MoveInventoryState widget to move inventory
  TextEditingController _productIdController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _isNotValidate = false;

  Future<void> relocateInventory() async { // Function to move inventory
    var response = await http.post(
      Uri.parse(moveInventory),
      body: {
        'product_id': _productIdController.text,
        'location': _locationController.text,
      },
    );

    if (response.statusCode == 200) { // Check if the response is successful
      print('Inventory moved successfully');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( // Show a success dialog if the inventory is moved successfully
            title: Text('Inventory Moved'),
            content: Text('The inventory has been moved successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else { // Show an error dialog if the inventory move fails
      print('Error relocating inventory: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('There was an error moving the inventory'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) { // Build the UI for the Move Inventory page
    return Scaffold(
      appBar: AppBar(
        title: Text('Move Inventory'),
        leading: IconButton( // Add a back button in the app bar
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding( // Add a title for the form
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter the Product Name and New Location: ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding( // Add text field for inventory name
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productIdController,
                decoration: InputDecoration(
                  labelText: 'Inventory ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding( // Add text field for location
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'New Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton( // Add a button to move the inventory
              onPressed: () {
                relocateInventory(); // Call the createInventory function
              },
              child: Text('Move Inventory'),
            ),
          ],
        ),
      ),
    );
  }
}
