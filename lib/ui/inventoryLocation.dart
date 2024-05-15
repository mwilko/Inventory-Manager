import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'productDescription.dart';

class Product { // Product class to store product details
  final String productName;
  final String manufacturer;
  final List<String> category;
  final String location;
  final int quantity;

  Product({ // Constructor to initialize the product details + ensure they are required
    required this.productName,
    required this.manufacturer,
    required this.category,
    required this.location,
    required this.quantity,
  });
}

class InventoryLocation extends StatefulWidget {
  @override
  _InventoryLocationState createState() => _InventoryLocationState();
}

class _InventoryLocationState extends State<InventoryLocation> {
  TextEditingController _locationController = TextEditingController(); // Controller for the location input field
  List<Product> _products = []; // List to store the products

  Future<void> _searchInventory(String location) async { // Function to search inventory based on location
    final response = await http.get(Uri.parse('http://localhost:3000/products?location=$location'));
    if (response.statusCode == 200) { // Check if the response is successful
      final List<dynamic> jsonData = json.decode(response.body);
      
      setState(() { // Clear the existing products list
        _products.clear();
      });

      for (int i = 0; i < jsonData.length; i++) { // Loop through the response data and add products to the list
        final productData = jsonData[i]; // Get the product data
        final categoryData = productData['category']; // Get the category data
        List<String> category; // Initialize an empty list to store the category
        
        if (categoryData is List) { // Check if the category data is a list
          // Handle category as a list of strings
          category = List<String>.from(categoryData);
        } else { // If the category data is not a list
          // Handle category as a single string
          category = [categoryData.toString()];
        }

        final product = Product( // Create a Product object
          productName: productData['product_name'], // Get the product name
          manufacturer: productData['manufacturer'], // Get the manufacturer
          category: category, // Get the category
          location: productData['location'], // Get the location
          quantity: int.parse(productData['quantity'].toString()), // Convert the quantity to an integer
        );
        setState(() { // Update the state with the new product
          _products.add(product);
        });
      }
    } else {
      showDialog( // Display an error dialog if the search fails
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to search inventory \n\nNo products found in the location $location.'),
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
  Widget build(BuildContext context) { // Build the UI
    return Scaffold(
      appBar: AppBar( // Display the app bar
        title: Text('Inventory Management'),
      ),
      body: Column( // Display the search input field and the list of products
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField( // Input field to enter the location filter
              controller: _locationController, 
              decoration: InputDecoration( 
                labelText: 'Enter Location Filter', // Label for the input field
                suffixIcon: IconButton( // Search button
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchInventory(_locationController.text); // Call the search inventory function
                  },
                ),
              ),
            ),
          ),
          Expanded( // Display the list of products
            child: ListView.builder(
              itemCount: _products.length, // Number of products in the list
              itemBuilder: (context, index) { // Build the list item
                return Card( // Display the product details in a card
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile( // Display the product name, category, and description button.
                    title: Text(_products[index].productName), // title being the product name
                    subtitle: Text(_products[index].category.toString()), // subtitle being the category
                    trailing: IconButton(
                      icon: Icon(Icons.description), // Description button
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDescription(
                              productName: _products[index].productName,
                              manufacturer: _products[index].manufacturer,
                              category: _products[index].category,
                              location: _products[index].location,
                              quantity: _products[index].quantity,
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