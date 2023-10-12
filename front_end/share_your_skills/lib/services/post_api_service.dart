import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PostApiService {
  final String token;
  PostApiService(this.token);

  Future<List<Post>> getUserAssignedPosts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/posts/getAssignedPosts'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
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
}
