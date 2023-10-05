import 'package:flutter/material.dart';
import 'package:share_your_skills/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  void logoutUser() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Home Page'),
    );
  }
}