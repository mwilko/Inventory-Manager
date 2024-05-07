const mongoose = require('mongoose');

// Connect to the database
mongoose.connect('mongodb+srv://mwilko:Wilko777!!!@inventory-manager.qzal1mm.mongodb.net/')
    .then(() => console.log('Connected to the database'))
    .catch((error) => console.log(`Connection error: ${error.message}`));

module.exports = mongoose; // Export the mongoose object