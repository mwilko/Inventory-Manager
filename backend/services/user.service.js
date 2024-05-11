const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class UserServices{
 
    static async registerUser(username, email,password){
        try{
                console.log("-----Username --- Email --- Password-----",username,email,password);
                
                const createUser = new UserModel({username, email,password});
                return await createUser.save();
        }catch(err){
            throw err;
        }
    }

    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }

    static async checkUser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = UserServices;