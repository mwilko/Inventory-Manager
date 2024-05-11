const mongoose = require('mongoose');

// Connect to the database
// format: mongodb+srv://<username>:<password>@<cluster>/<database>
mongoose.connect('mongodb+srv://mwilko:Wilko777!!!@inventory-manager.qzal1mm.mongodb.net/Inventory-Manager')
    .then(() => console.log('Connected to the MongoDB database...'))
    .catch((error) => console.log(`Connection error: ${error.message}`));

module.exports = mongoose; // Export the mongoose object