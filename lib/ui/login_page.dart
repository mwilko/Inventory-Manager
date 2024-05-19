import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home_page.dart';
import 'registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../api/config.dart';

class SignInPage extends StatefulWidget { // Sign-in page
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> { // State class for the sign-in page
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override 
  void initState() { // Initialize the state
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async { // Initialize shared preferences
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async { // Function to log in the user
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) { // Check if the email, password, and username are not empty
      var reqBody = { // Request body with the user details
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
      if (jsonResponse['status'] != null && jsonResponse['status']) { // Check if the response status is true
        var myToken = jsonResponse['token']; // Get the token from the response
        await prefs.setString('token', myToken); // Save the token to shared preferences
        await prefs.setString('username', usernameController.text); // Save the username to shared preferences
        print('Email: ${emailController.text}'); // Add this line to check the email value before saving
        await prefs.setString('email', emailController.text); // Save the email to shared preferences
        print('Email saved to prefs: ${prefs.getString('email')}'); // Add this line to check if the email is successfully saved

        Navigator.push( // Navigate to the dashboard page
            context, MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        showDialog( // Show an error dialog if the login details are invalid
          context: context,
          builder: (BuildContext context) {
            return AlertDialog( // Alert dialog
              title: Text("Error: Invalid Details"),
              content: Text("Please enter the correct login details.\nCheck your username, email, and password."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() { // Set the state to show an error if the details are not entered
        _isNotValidate = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error: No Details Entered"), // Alert dialog title
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
  Widget build(BuildContext context) { // Build the UI
    return SafeArea( 
      child: Scaffold(
        body: Container( 
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://gifdb.com/images/high/clicking-box-to-open-duck-inside-46iyikvod29znuwl.gif'), // background gif
              fit: BoxFit.cover, // Adjust the fit as per
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6), // Set the container color + opacity
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      HeightBox(10),
                      "Email Sign-In".text.size(22).color(Colors.black).make(),
                      TextField( // Text field for the username
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Username",
                            errorText: _isNotValidate ? "Enter Proper Info" : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                      ).p4().px24(),
                      TextField( // Text field for the email
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            errorText: _isNotValidate ? "Enter Proper Info" : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                      ).p4().px24(),
                      TextField( // Text field for the password
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            errorText: _isNotValidate ? "Enter Proper Info" : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                      ).p4().px24(),
                      GestureDetector( // Gesture detector for the login button
                        onTap: (){
                          loginUser();
                        },
                        child: HStack([ // Horizontal stack for the login button
                          VxBox(child: "LogIn".text.black.makeCentered().p16()).blue400.roundedLg.make(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector( // Gesture detector for the sign-up button
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration())); // Navigate to the registration page
          },
          child: Container( // Container for the sign-up button
              height: 25,
              color: Colors.lightBlue,
              child: Center(child: "Create a new Account..! Sign Up".text.white.makeCentered())),
        ),
      ),
    );
  }
}
