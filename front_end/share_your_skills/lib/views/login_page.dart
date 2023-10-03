import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_your_skills/views/home_page.dart';
import 'package:share_your_skills/views/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
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
  void loginUser () async{
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
     var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
     
     var response = await http.post(Uri.parse(url +"login"),
     headers: {"Content-Type": "application/json"},
     body: jsonEncode(regBody));
     var jsonResponse = jsonDecode(response.body);
     if(jsonResponse['status']){
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
       Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(token: myToken)),
                );
     }
     }
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Page',
              style: TextStyle(fontSize: 30),
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
                setState(() {});
              }, 
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrationPage()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    ));
  }
}
