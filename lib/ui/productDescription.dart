import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget { // ProductDescription widget to display product details
  final String productName;
  final String manufacturer;
  final List<String> category;
  final String location;
  final int quantity;
  final int productId;

  ProductDescription({ // Constructor to initialize the product details
    required this.productName,
    required this.manufacturer,
    required this.category,
    required this.location,
    required this.quantity,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) { // Build the UI of the ProductDescription widget
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Description'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text( // Display the product details
              'Product Name: $productName',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text( // Display the product details
              'Manufacturer: $manufacturer',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text( // Display the product details
              'Category: ${category.join(', ')}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text( // Display the product details
              'Location: $location',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text( // Display the product details
              'Quantity: $quantity',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text( // Display the product details
              'Product ID: $productId',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton( // Add a button to navigate back to the previous page
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}