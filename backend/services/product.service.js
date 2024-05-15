import ProductModel from '../models/product.model';

class ProductServices {
    static async addProduct(product_name, manufacturer, catagory, location, quantity) { // product_id isnt passed because its auto generated
        try {
            const createProduct = new ProductModel({ product_name, manufacturer, catagory, location, quantity});
            return await createProduct.save();
        } catch (err) {
            throw err;
        }
    }

    static async getProducts() {
        try {
            return await ProductModel.find();
        } catch (err) {
            console.log(err);
        }
    }

    static async getProductById(product_id) {
        try {
            return await ProductModel.findOne({ product_id });
        } catch (err) {
            console.log(err);
        }
    }

    static async updateProduct(product_id, product_name, manufacturer, catagory, location, quantity) {
        try {
            return await ProductModel.findOneAndUpdate({ product_id }, { product_name, manufacturer, catagory, location, quantity });
        } catch (err) {
            console.log(err);
        }
    }

    static async deleteProduct(product_id) {
        try {
            return await ProductModel.findOneAndDelete({ product_id });
        } catch (err) {
            console.log(err);
        }
    }
}