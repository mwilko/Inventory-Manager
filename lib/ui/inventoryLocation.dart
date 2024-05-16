import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'productDescription.dart';
import '/api/config.dart';

class Product { // Product class to store product details
  final String productName;
  final String manufacturer;
  final List<String> category;
  final String location;
  final int quantity;
  final int productId;

  Product({ // Product constructor
    required this.productName,
    required this.manufacturer,
    required this.category,
    required this.location,
    required this.quantity,
    required this.productId,
  });
}

class InventoryLocation extends StatefulWidget { // InventoryLocation widget to search inventory
  @override
  _InventoryLocationState createState() => _InventoryLocationState();
}

class _InventoryLocationState extends State<InventoryLocation> { // InventoryLocationState widget to search inventory
  TextEditingController _locationController = TextEditingController();
  List<Product> _products = [];

  Future<void> _searchInventory(String location) async { // Function to search inventory
    final response = await http.get(Uri.parse(getInventory + '$location'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData != null && jsonData.containsKey('data')) { // Check if the response contains data
        final List<dynamic> productList = jsonData['data'];

        setState(() {
          _products.clear(); // Clear the products list
        });

        for (int i = 0; i < productList.length; i++) { // Loop through the product list
          final productData = productList[i];
          final categoryData = productData['category'];
          List<String> category;

          if (categoryData is List) { // Check if the category data is a list
            category = List<String>.from(categoryData);
          } else {
            category = [categoryData.toString()];
          }

          print("Product ID is: ${productData['product_id']}"); // debug print statement

          final product = Product( // Create a new product object
            productName: productData['product_name'],
            manufacturer: productData['manufacturer'],
            category: category,
            location: productData['location'],
            quantity: int.parse(productData['quantity'].toString()),
            productId: int.parse(productData['product_id'].toString()),
          );
          setState(() {
            _products.add(product); // Add the product to the products list
          });
        }
      }
    } else {
      print('Failed to search inventory: ${response.statusCode}'); // debug print statement
      print('Location: $location'); // debug print statement
      print(response.body); // debug print statement
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog( // Show an error dialog if the inventory search fails
            title: Text('Error'),
            content: Text(
                'Failed to search inventory \n\nNo products found in the location $location.'),
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
  Widget build(BuildContext context) { // Build the UI for the Inventory Location page
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: Column(
        children: <Widget>[
          Padding( 
            padding: const EdgeInsets.all(8.0),
            child: TextField( // Add a text field for the location filter
              controller: _locationController,
              decoration: InputDecoration(
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
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(_products[index].productName), // Display the product name
                    subtitle: Text(_products[index].category.toString()), // Display the product category
                    trailing: IconButton(
                      icon: Icon(Icons.description),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDescription( // Navigate to the Product Description page
                              // Product details passed to the Product Description page
                              productName: _products[index].productName,
                              manufacturer: _products[index].manufacturer,
                              category: _products[index].category,
                              location: _products[index].location,
                              quantity: _products[index].quantity,
                              productId: _products[index].productId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
