import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:share_your_skills/models/skill.dart';

class UserApiService {
  final String baseUrl;

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
          /*
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
*/
          final user =
              extractUserFromToken(token, userJson); // Use the extract method
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
          /*
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          */
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

  Future<User?> extractUserFromToken(
      String token, Map<String, dynamic>? userJson) async {
    try {
      if (userJson != null) {
        final String? userId = userJson['_id'];
        final String? email = userJson['login']; 
        final String? name = userJson['name'];
        final List<String>? skillIds =
            List<String>.from(userJson['skillIds'] ?? []);

        // Create a mapping of skill IDs to skill names
        final Map<String, String> skillIdToName = await fetchSkills();
        /*
        {
          "65256b8601db3b3814171c5f": "Cleaning",
          "65256b7a01db3b3814171c5d": "Gardening",
          "65256b7101db3b3814171c5b": "Cooking",
        };
*/
        final List<String> userSkills = skillIds?.map((skillId) {
              final skillName = skillIdToName[skillId];
              if (skillName == null) {
                print("Unknown skill ID: $skillId");
                return skillId; // Use skill ID as a string if no mapping is found
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

  Future<String?> changeName(User user, String name) async {
    final token = user.token;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/changeName'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
          },
        body: jsonEncode({
          "name": name
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            'Updating name failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return null; // Handle login failure
      }
    } catch (e) {
      print('Updating name API Error: $e');
      return null; // Handle exceptions (e.g., network errors)
    }
  }

  Future<String?> changeEmail(User user, String email) async {
    final token = user.token;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/changeLogin'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
          },
        body: jsonEncode({
          "newLogin": email
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            'Updating email failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return null; // Handle login failure
      }
    } catch (e) {
      print('Updating email API Error: $e');
      return null; // Handle exceptions (e.g., network errors)
    }
  }

  Future<String?> changeAddress(User user, Address address) async {
    final token = user.token;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/changeAddress'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
          },
        body: jsonEncode({
          "city": address.city,
          "street": address.street,
          "houseNumber": address.houseNumber
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            'Updating address failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return null; // Handle login failure
      }
    } catch (e) {
      print('Updating address API Error: $e');
      return null; // Handle exceptions (e.g., network errors)
    }
  }

  Future<String?> addSkill(User user, String skillId) async {
    try {
      final token = user.token;
      final headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
      };
      final uri = Uri.http(
        'localhost:8000', 
        '/skills/addSkill', 
        {"skillId": skillId}
      );
      
      final response = await http.post(
        uri,
        headers: headers,
      );
    
      if (response.statusCode == 201) {
          return response.body;
      } else if ((response.statusCode == 500)) {
        print(
            'Skill already added. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return ''; // Handle the case where the server responds with an error
      } else{
        print(
            'Adding skill failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return ''; // Handle the case where the server responds with an error
      }
    } catch (e) {
      print('Adding skill failed API Error: $e');
      return ''; // Handle exceptions (e.g., network errors)
    }
  }

  Future<String?> deleteSkill(User user, String skillId) async {
    try {
      print('entering call ${skillId}');
      final token = user.token;
      final headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
      };
      final uri = Uri.http(
        'localhost:8000', 
        '/skills/deleteSkill', 
        {"skillId": skillId}
      );
      
      final response = await http.delete(
        uri,
        headers: headers,
      );
      if (response.statusCode == 201) {
          return response.body;
      } else if ((response.statusCode == 500)) {
        print(
            'Skill deleted. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return ''; // Handle the case where the server responds with an error
      } else{
        print(
            'Deleting skill failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return ''; // Handle the case where the server responds with an error
      }
    } catch (e) {
      print('Adding skill failed API Error: $e');
      return ''; // Handle exceptions (e.g., network errors)
    }
  }

  // get skills list
  Future<Map<String, String>> fetchSkills() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/skills'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, String> skillMap = {};

        for (final skillData in data) {
          final Skill skill = Skill.fromJson(skillData);
          skillMap[skill.skillId] = skill.name;
        }

        return skillMap;
      } else {
        throw Exception(
            'Failed to load skills. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load skills: $e');
    }
  }
}
