const mongoose = require('mongoose');
const { Schema } = mongoose;

const productSchema = new Schema({ // This schema is used to define the structure of the product object
    product_name: {
        type: String,
        required: true,
        unique: true,
    },
    manufacturer: {
        type: String,
        required: true,
    },
    category: {
        type: [String],//list of categories
        required: true,
    },
    location: {
        type: String,
        required: true,
    },
    quantity: {
        type: Number,
        required: true,
    },
    product_id: { // This field is used to uniquely identify a product (used for client-side operations)
        type: Number,
        required: false, // auto-generated, not needed in the request
        unique: true,
    },
    // Add more fields as needed
});

module.exports = mongoose.model('products', productSchema);
