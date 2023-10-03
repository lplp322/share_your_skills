import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: const Center(
        child: Text("Welcome home"),
      ),
    );
  }
}