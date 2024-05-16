const ProductServices = require('../services/product.service');

exports.addInventory = async (req, res, next) => { // This function is used to add a product to the inventory
    try {
        console.log("---req body---", req.body);
        const { product_name, manufacturer, category, location, quantity } = req.body; // Fixed typo: changed catagory to category
        if (!product_name || !manufacturer || !category || !location || !quantity) { // Fixed typo: changed catagory to category
            throw new Error(`Parameters are not correct: product_name - ${product_name}, manufacturer - ${manufacturer}, category - ${category}, location - ${location}, quantity - ${quantity}`);
        }
        const response = await ProductServices.addInventory(product_name, manufacturer, category, location, quantity); // Fixed typo: changed catagory to category
        res.json({ status: true, success: 'Product added successfully' });
        console.log(`Output: ${response}`); // Changed print to console.log for debugging
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.moveInventory = async (req, res, next) => { // This function is used to move a product to a different location
    try {
        console.log("---req body---", req.body);
        const { product_id, location } = req.body;
        if (!product_id || !location) {
            throw new Error(`Parameters are not correct: product_id - ${product_id}, location - ${location}`);
        }
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
