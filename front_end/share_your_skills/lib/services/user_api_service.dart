import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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

        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        final user = extractUserFromToken(token);
        return user;
      } else {
        return null; // Handle login failure
      }
    } catch (e) {
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

        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        final user = extractUserFromToken(token);
        return user;
      } else {
        return null; // Handle registration failure
      }
    } catch (e) {
      return null; // Handle exceptions (e.g., network errors)
    }
  }

  User? extractUserFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = jsonDecode(token);
      // Parse user information from the decoded token
      final String userId = decodedToken['user_id'];
      final String name = decodedToken['name'];
      final String email = decodedToken['email'];
      final List<String> skills = List<String>.from(decodedToken['skills']);

      return User(
        userId: userId,
        name: name,
        email: email,
        skills: skills,
      );
    } catch (e) {
      return null; // Handle token decoding errors
    }
  }

  // Add more API methods for other user-related actions.
}
