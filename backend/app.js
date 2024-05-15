const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const userRouter = require('./routers/user.router');
const productRouter = require('./routers/product.router');

const app = express();

app.use(cors()); // Enable CORS for all requests

app.use(bodyParser.json()); // Use the JSON body parser for parsing incoming requests

// Use the user router for handling user-related routes
app.use('/', userRouter);

// Use the product router for handling product-related routes
app.use('/', productRouter);

module.exports = app;
