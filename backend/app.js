const express = require('express'); // Import the express library here
const body_parser = require('body-parser'); // Import the body-parser library here
const userRouter = require('./routers/user.router'); // Import the user router here

const app = express(); // Create a new express application and store it in the app variable

app.use(body_parser.json()); // Tell the app to use the JSON body parser
app.use('/', userRouter); // Tell the app to use the user router

module.exports = app; // Export the app from this module