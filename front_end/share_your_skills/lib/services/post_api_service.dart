import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/models/post.dart';

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
          final posts = jsonResponse;
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
          final posts = jsonResponse;
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
        return await getPost(response.body);
      } else {
        // Handle other status codes as needed
        return post;
      }
    } catch (e) {
      print('Error: $e');
      return post;
    }
  }
  // update post
  Future<Post> updatePost(Post post) async {
    print("API - Update post is called");
    final url =
        Uri.parse('$baseUrl/updatePost'); // Replace with your actual API endpoint
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${user.token}',
    };

    final body = post.toJson(); // Convert the Post object to JSON

    try {
      final response =
          await http.put(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        return await getPost(post.id!);
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
      final response = await http.get(
        Uri.parse(
            '$baseUrl/getPost?postId=$postId'),
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
  // get my past posts
  Future<List<Post>> getMyPastPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getMyPastPosts'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse is List) {
          final posts = jsonResponse;
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

  Future<String> findSkillIdByName(String skillName) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/skills/getSkillId?name=$skillName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
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
  //delet post
  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deletePost?postId=$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        print('Post deleted successfully');
      } else {
        throw Exception(
            'Failed to delete post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
  // get user name by id
  Future<String> getUserNameById(String userId) async {
     print("API - getUserNameById is called");
    try {
     
      final response = await http.get(
        Uri.parse('$baseUrl/getUser?userId=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        // extract user name from response

        final jsonData = json.decode(response.body);
        final userName = jsonData['name'];
        print('User name for $userId: $userName');
        return userName;
      } else {
        throw Exception(
            'Failed to load user name. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user name: $e');
    }
  }
}
