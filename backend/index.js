const app = require('./app'); // Import the app from app.js
const db = require('./config/db'); // Import the db from db.js
const UserModel = require('./models/user.model'); // Import the UserModel from user.model.js

const port = 3000; // Set the port to 3000

app.get('/', (req, res) => { // Create a new route that listens on the / path
  res.send('Hello World!');
});
app.post('/', (req, res) => {
  res.send('Received a POST request');
});

app.listen(port, () => { // Tell the app to listen on port 3000
  console.log(`App running on port: http://localhost:${port}`);
});