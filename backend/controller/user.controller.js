const UserServices = require('../services/user.service');

exports.register = async (req, res, next) => { // This function is used to add a product to the inventory
    try {
        console.log("---req body---", req.body);
        const { username, email, password } = req.body;
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            throw new Error(`Email ${email}, Already Registered`)
        }
        const response = await UserServices.registerUser(username, email, password);

        res.json({ status: true, success: 'User registered successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.login = async (req, res, next) => { // This function is used to move a product to a different location
    try {

        const { username, email, password } = req.body;

        if (!username || !email || !password) {
            throw new Error('Parameter are not correct');
        }
        let user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(404).json({ error: 'User does not exist' });
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }

        // Creating Token

        let tokenData;
        tokenData = { _id: user._id, email: user.email };
    

        const token = await UserServices.generateAccessToken(tokenData,"secret","1h")

        res.status(200).json({ status: true, success: "sendData", token: token });
    } catch (error) {
        return res.status(500).json({ status: false, error: error.message });
    }
}