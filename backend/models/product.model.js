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
    catagory: {
        type: String,
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
    // Add more fields as needed
});

module.exports = mongoose.model('products', productSchema);
