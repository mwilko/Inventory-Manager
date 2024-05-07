const userModel = require('../model/user.model');

class UserService {
    static async registerUser(email, password) {
        try{
            const user = await userModel.create({email, password});
            return await createUser.save();
        }catch(error){
            throw console.error(error);
        }
    }
}
module.exports = UserService;