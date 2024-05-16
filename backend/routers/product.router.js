const express = require('express');
const router = express.Router();
const ProductController = require('../controller/product.controller');

router.post('/addInventory', ProductController.addInventory);
router.get('/moveInventory', ProductController.moveInventory);
router.get('/getInventory', ProductController.getInventory);


// Add routes for updating and deleting products as needed

module.exports = router;
