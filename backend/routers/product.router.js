const express = require('express');
const router = express.Router();
const ProductController = require('../controller/product.controller');

router.post('/addInventory', ProductController.addInventory); // This route is used to add a product to the inventory
// E.G: localhost:3000/moveInventory/1/RAC5
router.put('/moveInventory/:id/:newLocation', ProductController.moveInventory); // This route is used to move a product to a different location
router.get('/getInventory', ProductController.getInventory); // This route is used to get all products in the passed location

// Add routes for updating and deleting products as needed

module.exports = router;
