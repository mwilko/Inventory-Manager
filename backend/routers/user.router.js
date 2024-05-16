const router = require("express").Router();
const UserController = require('../controller/user.controller');

router.post("/register",UserController.register); // This route is used to add a product to the inventory

router.post("/login", UserController.login); // This route is used to move a product to a different location


module.exports = router;