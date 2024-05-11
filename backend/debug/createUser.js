const UserModel = require('../models/user.model');

const createUser = async () => {
    const newUser = new UserModel({
        username: 'testuser',
        password: 'testpassword',
        email: 'testuser@example.com', // add this line
    });

    try {
        await newUser.save();
        console.log('User created successfully');
    } catch (err) {
        console.log('Error creating user:', err);
    }
};

createUser();