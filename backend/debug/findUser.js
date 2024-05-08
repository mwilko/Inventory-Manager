const express = require('express');
const UserModel = require('../model/user.model');
const app = express();

app.use(express.json()); // for parsing application/json

app.post('/', async (req, res) => {
    const { username, email, password } = req.body;

    const newUser = new UserModel({
        username,
        email,
        password
    });

    try {
        await newUser.save();
        res.status(201).send('User created successfully');
    } catch (err) {
        console.error('Error creating user:', err);
        res.status(500).send('Error creating user');
    }
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});