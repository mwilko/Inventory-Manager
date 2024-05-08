const express = require('express');
const bodyParser = require('body-parser');
const userRouter = require('./routers/user.router');
const productRouter = require('./routers/product.router');
const ToDoRoute = require('./routers/todo.router');

const app = express();

app.use(bodyParser.json()); // Use the JSON body parser for parsing incoming requests

// Use the user router for handling user-related routes
app.use('/', userRouter);

// Use the product router for handling product-related routes
app.use('/', productRouter);

// Use the ToDo router for handling ToDo-related routes
app.use('/', ToDoRoute);

module.exports = app;
