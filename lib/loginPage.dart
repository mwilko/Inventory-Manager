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
  // creating three TextEditingController objects to get the user input for email, password, and username.
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() { // A function to initialize the state of the SignInPage.
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{ // A function to initialize the shared preferences.
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async{ // A function to login the user.
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && usernameController.text.isNotEmpty){

      var reqBody = { // Create a map of the data you want to send to the API
        "username": usernameController.text,
        "email":emailController.text,
        "password":passwordController.text
      };
    
      var response = await http.post(Uri.parse(login), // Send a POST request to the API
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(reqBody) // Convert the map to a JSON string
      );

      var jsonResponse = jsonDecode(response.body); // Decode the response from the API.
      if(jsonResponse['status'] != null && jsonResponse['status']){
          var myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(token: myToken)));
      }else{
        print('Something went wrong');
      }

    }
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the SignInPage.
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0XFFF95A3B),const Color(0XFFF96713)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0,0.8],
                tileMode: TileMode.mirror
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //CommonLogo(),
                  HeightBox(10),
                  "Email Sign-In".text.size(22).yellow100.make(),
                  TextField(
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
                  TextField(
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
                  TextField(
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
                  GestureDetector(
                    onTap: (){
                        loginUser();
                    },
                    child: HStack([
                      VxBox(child: "LogIn".text.white.makeCentered().p16()).green600.roundedLg.make(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration()));
          },
          child: Container(
              height: 25,
              color: Colors.lightBlue,
              child: Center(child: "Create a new Account..! Sign Up".text.white.makeCentered())),
        ),
      ),
    );
  }
}