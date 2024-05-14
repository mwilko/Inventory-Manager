import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_manager/dashboard.dart';
import 'package:inventory_manager/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
//import 'applogo.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignInPage extends StatefulWidget { // A StatefulWidget to sign in the user.
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> { // A State class to handle the state of the SignInPage.
  // creating three TextEditingController objects to get the user input for password, and username.
  TextEditingController emailController = TextEditingController(); // Not really needed for sign-in
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() { // A function to initialize the state of the SignInPage.
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{ // A function to initialize the shared preferences.
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      usernameController.text.isNotEmpty) {
    var reqBody = {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text
    };

    var response = await http.post(
      Uri.parse(login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] != null && jsonResponse['status']) {
      var myToken = jsonResponse['token'];
      var username = jsonResponse['username'];
      await prefs.setString('token', myToken);
      await prefs.setString('username', usernameController.text); // Save the entered username
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error: Invalid Details"),
            content: Text("Please enter the correct login details.\nCheck your username, email, and password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    }
  } else {
    setState(() {
      _isNotValidate = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error: No Details Entered"),
            content: Text("Please enter your login details"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    });
  }
}

  @override
  Widget build(BuildContext context) { // Build the UI of the SignInPage.
    return SafeArea( // A widget to make sure that the content is displayed within the safe area of the screen.
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 47, 231, 255),Color.fromARGB(255, 47, 231, 255)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0,0.8],
                tileMode: TileMode.mirror
            ),
          ),
          child: Center( // A widget to center the content of the SignInPage.
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //CommonLogo(),
                  HeightBox(10),
                  "Email Sign-In".text.size(22).color(Colors.black).make(), // A widget to display the title of the SignInPage.
                  TextField( // A widget to get the user input for the email.
                    controller: usernameController, // Set the controller of the TextField to the emailController.
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true, 
                        fillColor: Colors.white,
                        hintText: "Username", // Set the placeholder text of the TextField.
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: OutlineInputBorder( // Set the border of the TextField.
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(), 
                  // Not really needed for sign-in although probably for registration
                  TextField( // A widget to get the user input for the password.
                    controller: emailController, // Set the controller of the TextField to the passwordController.
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  TextField( // A widget to get the user input for the password.
                    controller: passwordController , // Set the controller of the TextField to the passwordController.
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password", // Set the placeholder text of the TextField.
                        errorText: _isNotValidate ? "Enter Proper Info" : null, // error handling
                        border: OutlineInputBorder( 
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  GestureDetector( // A widget to handle the tap event on the LogIn button.
                    onTap: (){
                        loginUser(); // Call the loginUser function when the user taps the LogIn button.
                    },
                    child: HStack([ // A widget to display the LogIn button.
                      VxBox(child: "LogIn".text.black.makeCentered().p16()).blue400.roundedLg.make(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector( // A widget to handle the tap event on the Sign Up button.
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration()));
          },
          child: Container( // A widget to display the Sign Up button.
              height: 25,
              color: Colors.lightBlue,
              child: Center(child: "Create a new Account..! Sign Up".text.white.makeCentered())),
        ),
      ),
    );
  }
}