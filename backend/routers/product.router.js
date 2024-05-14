const express = require('express');
const router = express.Router();
const Product = require('../models/product.model');

// Create a new product
router.post('/products', async (req, res) => {
    try {
        const product = new Product(req.body);
        await product.save();
        res.status(201).send(product);
    } catch (error) {
        res.status(400).send(error);
    }
});

// Get all products in a specific location
router.get('/products', async (req, res) => {
    try {
        const location = req.query.location;
        const products = await Product.find({ location });
        res.send(products);
    } catch (error) {
        res.status(500).send(error);
    }
});

// Add routes for updating and deleting products as needed

module.exports = router;
