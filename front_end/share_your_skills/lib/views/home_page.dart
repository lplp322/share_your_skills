import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userId;
  late String? userName;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    userName = jwtDecodedToken['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("User ID: $userId"),
            Text("User Name: $userName"),
          ],
        ),
      ),
    );
  }
}
