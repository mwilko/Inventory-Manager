const ProductModel =  require("../models/product.model");

class ProductServices { // This class is used to interact with the database

    static async addInventory(product_name, manufacturer, categories, location, quantity) { // This function is used to add a product to the inventory
        try { // whats happening with the categories is that it is being passed as an array, so we need to pass it as an array
            const createProduct = new ProductModel({ product_name, manufacturer, category: categories, location, quantity}); // Create a new product object
            console.log("addInventory called... (product.service.js)");
            const savedProduct = await createProduct.save();
            console.log("Product saved: ", savedProduct);
            return savedProduct;
        } catch (err) {
            console.error("Error in addInventory: ", err);
            throw err;
        }
    }

    static async moveInventory(product_id, location) {
        try {
            // Find the product in the database and update its location (One = product_id, and update its location to the new location)
            const relocateInventory = await ProductModel.findOneAndUpdate({ product_id: product_id }, { location }, { new: true });
            console.log("Product found for moving: ", relocateInventory);
            return relocateInventory;
        } catch (err) {
            console.error("Error in moveInventory: ", err);
            throw err;
        }
    }

    static async getInventory(location) { // location is passed to find products in that location
        try {
            const products = await ProductModel.find({ location }); // Get all products from the database based on location
            console.log("Products found: ", products);
            return products; // Return the products
        } catch (error) {
            console.error("Error in getInventory: ", error);
            throw error; // Throw any errors encountered
        }
    }
}
module.exports = ProductServices;