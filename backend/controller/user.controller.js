const UserService = require('../services/user.services');

exports.register = async (req, res, next) => {
    const { email, password } = req.body;
    try {
        const {email, password} = req.body;
        const successRes = await UserService.registerUser(email, password);
        res.json({status: true, message: 'User registered successfully'});
    } catch (error) {
        res.status(500).json(error);
    }
}