import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:share_your_skills/models/skill.dart';

class PostApiService {
  User user;
  String baseUrl = 'http://localhost:8000/posts';
  PostApiService(this.user) {
    print('PostAPiService initialized');
  }

  Future<List<Post>> getUserAssignedPosts() async {
    try {
      print("API for fetch is called");
      final response = await http.get(
        Uri.parse('$baseUrl/getAssignedPosts'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse is List) {
          final posts = jsonResponse as List;
          for (var post in posts) {
            print(post["title"]);
          }
          return jsonResponse
              .map<Post>((postJson) => Post.fromJson(postJson))
              .toList();
        } else {
          print('Unexpected response format. Response Body: ${response.body}');
          return []; // Handle cases where the response format is not as expected
        }
      } else {
        print(
            'Posts failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return []; // Handle the case where the server responds with an error
      }
    } catch (e) {
      print('Posts API Error: $e');
      return []; // Handle exceptions (e.g., network errors)
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getMyPosts'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse is List) {
          final posts = jsonResponse as List;
          for (var post in posts) {
            print(post["title"]);
          }
          return jsonResponse
              .map<Post>((postJson) => Post.fromJson(postJson))
              .toList();
        } else {
          print('Unexpected response format. Response Body: ${response.body}');
          return []; // Handle cases where the response format is not as expected
        }
      } else {
        print(
            'Posts failed. Status Code: ${response.statusCode}, Response Body: ${response.body}');
        return []; // Handle the case where the server responds with an error
      }
    } catch (e) {
      print('Posts API Error: $e');
      return []; // Handle exceptions (e.g., network errors)
    }
  }

  // add post
  Future<Post> addPost(Post post) async {
    print("API - Add post is called");
    final url =
        Uri.parse('$baseUrl/addPost'); // Replace with your actual API endpoint
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${user.token}',
    };

    final body = post.toJson(); // Convert the Post object to JSON

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        // Successfully created a new post
        final postId = response.body; // Using response.body as the postId
        return post;
      } else {
        // Handle other status codes as needed
        return post;
      }
    } catch (e) {
      print('Error: $e');
      return post;
    }
  }

  Future<Post> getPost(String postId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getPost'),
        body: json.encode({'postId': postId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and create a Post object
        final jsonData = json.decode(response.body);
        final post = Post.fromJson(jsonData);
        return post;
      } else {
        // Handle any error or return null if not found
        throw Exception(
            'Failed to load post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions or errors
      print('Error: $e');
      throw Exception('Failed to load post. Error: $e');
    }
  }

  Future<String> findSkillIdByName(String skillName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getSkillId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
        body: json.encode({'name': skillName}),
      );

      if (response.statusCode == 200) {
        final skillId = response.body;
        print('Skill ID for $skillName: $skillId');
        return skillId;
      } else {
        throw Exception(
            'Failed to load skill ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load skill ID: $e');
    }
  }
}
