import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Future<void> createInventory() async { // Function to create new inventory
    var response = await http.post(
      Uri.parse(addInventory), // Send a POST request to the API
      body: {
        'product_name': _productNameController.text,
        'manufacturer': _manufacturerController.text,
        'category': _categoryController.text,
        'location': _locationController.text,
        'quantity': _quantityController.text,
      },
    );

    if (response.statusCode == 200) { // Check if the response is successful
      // Inventory created successfully
      print('Inventory created successfully');
    } else {
      // Error creating inventory
      print('Error creating inventory: ${response.statusCode}');
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
