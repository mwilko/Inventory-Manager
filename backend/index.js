const app = require('./app'); // Import the app from app.js

const port = 3000; // Set the port to 3000

app.get('/', (req, res) => { // Create a new route that listens on the / path
  res.send('Hello World!');
});

app.listen(port, () => { // Tell the app to listen on port 3000
  console.log(`App running on port: http://localhost:${port}`);
});