import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:jwt_decoder/jwt_decoder.dart';

class UserApiService {
  final String baseUrl; // Replace with your API base URL

  UserApiService(this.baseUrl);

  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login": email,
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        final token = response.body; // JWT token
        // print('Login successful. Token: $token');

        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        final user = extractUserFromToken(token);
        return user;
      } else {
        print(
            'Login failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return null; // Handle login failure
      }
    } catch (e) {
      print('Login API Error: $e');
      return null; // Handle exceptions (e.g., network errors)
    }
  }
Future<User?> registerUser(String name, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "login": email,
        "password": password,
        "name": name,
      }),
    );

    if (response.statusCode == 200) {
      final token = response.body; // JWT token

      if (token != null && token.isNotEmpty) {
        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        final user = extractUserFromToken(token);
        return user; // Registration successful, return user object
      } else {
        print('Token is null or empty');
        return null; // Registration failed, return null
      }
    } else if (response.statusCode == 400) {
      // Registration failed, extract the error message
      final jsonResponse = jsonDecode(response.body);
      final errorMessage = jsonResponse['error'] ?? 'Registration failed';
      print('Registration failed: $errorMessage');
      return null; // Registration failed, return null
    } else {
      print(
          'Registration failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
      return null; // Handle other errors, return null
    }
  } catch (e) {
    print('Registration API Error: $e');
    return null; // Handle exceptions (e.g., network errors), return null
  }
}



  User? extractUserFromToken(String token) {
    try {
      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Check if the expected fields are present in the decoded token
        if (decodedToken.containsKey('_id') &&
            decodedToken.containsKey('name')) {
          final String userId = decodedToken['_id'];
          final String name = decodedToken['name'];

          return User(
            userId: userId,
            name: name,
            token: token,
          );
        } else {
          print("Token is missing expected fields");
          return null;
        }
      } else {
        print("Token is null or empty");
        return null;
      }
    } catch (e) {
      print("Token Decoding Error: $e");
      return null; // Handle token decoding errors
    }
  }

  // Add more API methods for other user-related actions.
}
