import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/skill.dart';

class SkillApiService {
  final String token;
  SkillApiService(this.token);

  Future<List<Skill>> getAllSkills() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/skills'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("-------------");
        print(jsonResponse);
        if (jsonResponse is List) {
          final skills = jsonResponse as List;
          for (var skill in skills) {
            print(skill["name"]);
          }
          return jsonResponse
              .map<Skill>((skillJson) => Skill.fromJson(skillJson))
              .toList();
        } else {
          print('Unexpected response format. Response Body: ${response.body}');
          return []; // Handle cases where the response format is not as expected
        }
      } else {
        print(
            'Skills failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return []; // Handle the case where the server responds with an error
      }
    } catch (e) {
      print('Skills API Error: $e');
      return []; // Handle exceptions (e.g., network errors)
    }
  }

  
}
