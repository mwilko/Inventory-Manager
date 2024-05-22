import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import the dart convert library for put handling
import '../../api/config.dart';

class AddInventory extends StatelessWidget { // AddInventory widget to create new inventory
  @override
  Widget build(BuildContext context) {
    return _AddInventoryForm();
  }
}

class _AddInventoryForm extends StatefulWidget { // AddInventoryForm widget to create new inventory
  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends State<_AddInventoryForm> { // AddInventoryState widget to create new inventory
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _manufacturerController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  bool _isNotValidate = false;

  Future<void> createInventory() async {
    String url = addInventory;
    print('URL: $url');

    print('Raw Category Input: "${_categoryController.text}"'); // debug

    // split and trim categories
    List<String> categories = _categoryController.text.split(',').map((category) => category.trim()).toList();

    //Debug: Print the processed categories list
    print('Processed Categories: $categories');

    var response = await http.post(
      Uri.parse(addInventory),
      headers: <String, String>{ // Send a POST request to the API
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{ // Encode the body as JSON
        'product_name': _productNameController.text,
        'manufacturer': _manufacturerController.text,
        'category': categories, // categories list
        'location': _locationController.text, 
        'quantity': _quantityController.text,
      }),
    );

    if (response.statusCode == 200) { // Check if the response is successful
      print('Inventory created successfully');
      print('response body: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Inventory Created'),
            content: Text('The inventory has been created successfully'),
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
    } else { // Show an error dialog if the inventory creation fails
      print('Error creating inventory: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Creating Inventory'),
            content: Text( // Show the error message
              'There was an error creating the inventory\n\n'
              '${_productNameController.text}, ${_manufacturerController.text}, '
              '${_categoryController.text}, ${_locationController.text}, ${_quantityController.text} '
              '\n(Error ${response.statusCode})',
            ),
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
  Widget build(BuildContext context) { // Build the UI for the Add Inventory page
    return Scaffold(
      appBar: AppBar( // Add app bar with back button
        title: Text('Add Inventory'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Container( // Add a container to hold the form
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'State the Details of the Inventory: ', // Add a title for the form
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding( // Add text field for product name
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding( // Add text field for manufacturer
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: 'Manufacturer',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding( // Add text field for category
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category/Categories',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding( // Add text field for location
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding( // Add text field for quantity
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton( // Add button to create inventory
              onPressed: () {
                createInventory();
              },
              child: Text('Add Inventory'),
            ),
          ],
        ),
      ),
    );
  }
}
