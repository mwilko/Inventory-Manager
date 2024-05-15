const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
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
