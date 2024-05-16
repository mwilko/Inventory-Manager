const ProductServices = require('../services/product.service');

exports.addInventory = async (req, res, next) => { // This function is used to add a product to the inventory
    try {
        console.log("---req body---", req.body);
        const { product_name, manufacturer, category, location, quantity } = req.body;
        if (!product_name || !manufacturer || !catagory || !location || !quantity) {
            throw new Error(`Parameter are not correct: product_name - ${product_name}, manufacturer - ${manufacturer}, category - ${category}, location - ${location}, quantity - ${quantity}`);
        }
        const response = await ProductServices.addInventory(product_name, manufacturer, catagory, location, quantity);
        res.json({ status: true, success: 'Product added successfully' });
        print(`Output: ${response}`); // This line is added to print the response to debug console
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
            throw new Error(`Parameter are not correct: product_id - ${product_id}, location - ${location}`);
        }
        const response = await ProductServices.moveInventory(product_id, location);
        res.json({ status: true, success: 'Product moved successfully' });
        print(`Output: ${response}`); // This line is added to print the response to debug console
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.getInventory = async (req, res, next) => { // This function is used to get all products from the inventory
    try {
        const response = await ProductServices.getInventory();
        res.json({ status: true, success: 'Products fetched successfully', data: response });
        print(`Output: ${response}`); // This line is added to print the response to debug console
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}