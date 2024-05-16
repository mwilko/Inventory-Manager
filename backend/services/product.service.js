const ProductModel =  require("../models/product.model");

class ProductServices { // This class is used to interact with the database
    static async addInventory(product_name, manufacturer, catagory, location, quantity) { // product_id isnt passed because its auto generated
        try {
            const createProduct = new ProductModel.addInventory({ product_name, manufacturer, catagory, location, quantity});
            return await createProduct.save();
        } catch (err) {
            throw err;
        }
    }

    static async moveInventory(product_id, location) { // product_id and location are passed
        try {
            const relocateInventory = await ProductModel.moveInventory({ product_id, location });
            return await relocateInventory.save();
        }
        catch (err) {
            throw err;
        }
    }

    static async getInventory() {
        try {
            return await ProductModel.find();
        } catch (err) {
            console.log(err);
        }
    }

    // static async getProductById(product_id) {
    //     try {
    //         return await ProductModel.findOne({ product_id });
    //     } catch (err) {
    //         console.log(err);
    //     }
    // }

    // static async updateProduct(product_id, product_name, manufacturer, catagory, location, quantity) {
    //     try {
    //         return await ProductModel.findOneAndUpdate({ product_id }, { product_name, manufacturer, catagory, location, quantity });
    //     } catch (err) {
    //         console.log(err);
    //     }
    // }

    // static async deleteProduct(product_id) {
    //     try {
    //         return await ProductModel.findOneAndDelete({ product_id });
    //     } catch (err) {
    //         console.log(err);
    //     }
    // }
}