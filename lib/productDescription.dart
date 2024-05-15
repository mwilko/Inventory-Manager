import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget { // ProductDescription widget to display product details
  final String productName;
  final String manufacturer;
  final List<String> category;
  final String location;
  final int quantity;

  ProductDescription({ // Constructor to initialize the product details
    required this.productName,
    required this.manufacturer,
    required this.category,
    required this.location,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) { // Build method to create the widget
    return Card(
      child: ListTile( // ListTile to display the product details
        title: Text(productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[ // Display the product details
            Text('Manufacturer: $manufacturer'),
            Text('Category: ${category.join(', ')}'),
            Text('Location: $location'),
            Text('Quantity: $quantity'),
            ElevatedButton( // Back button to navigate back to the previous screen
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