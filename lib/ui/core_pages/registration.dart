import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
//import 'applogo.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import '../../api/config.dart';

class Registration extends StatefulWidget { // A StatefulWidget to register the user.
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  // creating three TextEditingController objects to get the user input for email, password, and username.
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false; // A boolean variable to check if the user has entered the proper information or not.

  void registerUser() async{ // A function to register the user.
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && usernameController.text.isNotEmpty){

      var regBody = {
        "username": usernameController.text,
        "email":emailController.text,
        "password":passwordController.text
      }; // A map of the data you want to send to the API.

      var response = await http.post(Uri.parse(registration), // Send a POST request to the API
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body); // Decode the response from the API.

      //print(jsonResponse['status']); // error handling

      if(jsonResponse['status']){ // Check if the API returns a 200 OK response
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
      }else{
        print("SomeThing Went Wrong");
      }
    }else{ // If the user has not entered the proper information, set the _isNotValidate variable to true.
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the Registration page.
    return SafeArea(
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //CommonLogo(),
                  HeightBox(10),
                  "Sign Up!".text.size(22).color(Colors.black).make(), // A widget to display the title of the SignInPage.
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(), // A TextField to get the username from the user.
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(), // A TextField to get the email from the user.
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(icon: Icon(Icons.copy),onPressed: (){
                          final data = ClipboardData(text: passwordController.text);
                          Clipboard.setData(data);
                        },),
                        prefixIcon: IconButton(icon: Icon(Icons.password),onPressed: (){
                          String passGen =  generatePassword();
                          passwordController.text = passGen;
                          setState(() {

                          });
                        },),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(), // A TextField to get the password from the user.
                  HStack([
                    GestureDetector(
                      onTap: ()=>{
                        registerUser()
                      },
                        child: VxBox(child: "Register".text.black.makeCentered().p16()).blue400.roundedLg.make().px16().py16(),
                    ),
                  ]), // A GestureDetector to register the user.
                  GestureDetector(
                    onTap: (){
                      print("Sign In");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                    }, // A GestureDetector to navigate to the SignIn page.
                    child: HStack([
                      "Already Registered?".text.make(),
                      " Sign In".text.white.make()
                    ]).centered(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() { // A function to generate a random password.
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}