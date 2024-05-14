import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_manager/dashboard.dart';
import 'package:inventory_manager/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
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
        await prefs.setString('username', usernameController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://gifdb.com/images/high/clicking-box-to-open-duck-inside-46iyikvod29znuwl.gif'), // Replace 'YOUR_IMAGE_URL_HERE' with your actual image URL
              fit: BoxFit.cover, // Adjust the fit as per your requirement
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6), // Set the container color
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      HeightBox(10),
                      "Email Sign-In".text.size(22).color(Colors.black).make(),
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
