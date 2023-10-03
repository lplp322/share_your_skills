import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_your_skills/views/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController? nameController = TextEditingController();
  bool _isNotValidate = false;
  String? errorMessage;
  late SharedPreferences prefs;
  final url = 'http://localhost:8000/users/';
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void registerUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController!.text.isNotEmpty) {
      var regBody = {
        "login": emailController.text,
        "password": passwordController.text,
        "name": nameController!.text,
      };

      var response = await http.post(
        Uri.parse(url + "register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        var myToken = response.body; // Extract the token directly
        prefs.setString('token', myToken);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(token: myToken)),
        );
      } else {
        setState(() {
          errorMessage =
              response.body; // Store the error message from the server
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Registration Page',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Full Name",
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email",
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Password",
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              registerUser();
            },
            child: Text('Register'),
          ),
          SizedBox(
            height: 10,
          ),
          errorMessage != null
              ? Text(
                  errorMessage!,
                  style:
                      TextStyle(color: Colors.red), // Display error in red text
                )
              : SizedBox(),
        ],
      ),
    ));
  }
}
