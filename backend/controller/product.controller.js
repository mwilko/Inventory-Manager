const ProductServices = require('../services/product.service');

exports.addInventory = async (req, res, next) => { // This function is used to add a product to the inventory
    try {
        console.log("---req body---", req.body);
        const { product_name, manufacturer, category, location, quantity } = req.body; // Get the product details from the request body
        if (!product_name || !manufacturer || !Array.isArray(category) || !location || !quantity) { // Check if the parameters are correct
            throw new Error(`Parameters are not correct: product_name - ${product_name}, manufacturer - ${manufacturer}, category - ${category}, location - ${location}, quantity - ${quantity}`);
        }
        const response = await ProductServices.addInventory(product_name, manufacturer, category, location, quantity);
        res.json({ status: true, success: 'Product added successfully' });
        console.log(`Output: ${response}`); //debug
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.moveInventory = async (req, res, next) => { // This function is used to move a product to a different location
    try {
        console.log(req); // debug
        console.log("---req params---", req.params); // debug
        const { id: product_id, newLocation: location } = req.params;
        if (product_id == null || location == null) {
            throw new Error(`Parameters are not correct: product_id - ${product_id}, location - ${location}`);
        }
        console.log(`Product ID: ${product_id}, Location: ${location}`);
        const response = await ProductServices.moveInventory(product_id, location);
        res.json({ status: true, success: 'Product moved successfully' });
        console.log(`Output: ${response}`); // Changed print to console.log for debugging
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.getInventory = async (req, res, next) => { // This function is used to get all products from the inventory
    try {
        const location = req.query.location; // Get the location from the query
        const response = await ProductServices.getInventory(location);
        res.json({ status: true, success: 'Products fetched successfully', data: response });
        console.log(`Output: ${response}`); // Changed print to console.log for debugging
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
