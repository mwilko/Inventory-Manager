const  mongoose  = require('mongoose');
const bcrypt  = require('bcrypt');

const db = require('../config/db');

const { Schema } = mongoose;

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    username: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    });

userSchema.pre('save', async function() {
    try {
        user = this;
        const salt = await bcrypt.genSalt(10); // Generate a salt
        const hash = await bcrypt.hash(user.password, salt); // Hash the password
        
        user.password = hash; // Set the password to the hash
    } catch (error) {
        next(error);
    }
});

const UserModel = db.model('user', userSchema);

module.exports = UserModel;