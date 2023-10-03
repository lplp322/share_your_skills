import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String email;
  @override
   void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
   // print(JwtDecoder.decode(widget.token));
   email = jwtDecodedToken['login'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Text(email),
      ),
    );
  }
}