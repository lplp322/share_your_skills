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
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];
        final userJson = jsonResponse['user'];

        if (token != null && token.isNotEmpty && userJson != null) {
          // Save the token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);

          final user = extractUserFromToken(token, userJson); // Use the extract method
          return user;
        } else {
          print('Token or user data is null or empty');
          return null; // Handle login failure
        }
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

  Future<User?> registerUser(User user, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login": user.email,
          "password": password,
          "name": user.name,
          "address": {
            "city": user.address?.city,
            "street": user.address?.street,
            "houseNumber": user.address?.houseNumber,
          },
          "skillIds": user.skillIds,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];
        final userJson = jsonResponse['user'];

        if (token != null && token.isNotEmpty && userJson != null) {
          // Save the token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);

          final extractedUser = extractUserFromToken(token, userJson);

          return extractedUser; // Registration successful, return user object
        } else {
          print('Token or user data is null or empty');
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

  User? extractUserFromToken(String token, Map <String, dynamic>? userJson) {

    try {
      if (userJson != null) {
        final String? userId = userJson['_id'];
        final String? email = userJson['login']; // Update to 'email' for email
        final String? name = userJson['name'];
        final List<String>? skillIds =
            List<String>.from(userJson['skillIds'] ?? []);

        // Create a mapping of skill IDs to skill names
        final Map<String, String> skillIdToName = {
          "65256b8601db3b3814171c5f": "Cleaning",
          "65256b7a01db3b3814171c5d": "Gardening",
          "65256b7101db3b3814171c5b": "Cooking",
        };

        final List<String> userSkills = skillIds?.map((skillId) {
              final skillName = skillIdToName[skillId];
              if (skillName == null) {
                print("Unknown skill ID: $skillId");
                return skillId; // Use skill ID if no mapping found
              }
              return skillName;
            }).toList() ??
            [];

        final Map<String, dynamic>? addressData = userJson['address'];
        final String? city = addressData?['city'];
        final String? street = addressData?['street'];
        final String? houseNumber = addressData?['houseNumber'];


        // Create a new User object with updated information
        final updatedUser = User(
          userId: userId,
          name: name ?? '', // Provide a default value if name is null
          email: email ?? '', // Provide a default value if email is null
          skillIds: userSkills,
          token: token,
          address: Address(
            city: city,
            street: street,
            houseNumber: houseNumber,
          ),
        );

        return updatedUser;
      } else {
        print("User data is null");
        return null;
      }
    } catch (e) {
      print("User Data Extraction Error: $e");
      return null; // Handle data extraction errors
    }
  }
}
