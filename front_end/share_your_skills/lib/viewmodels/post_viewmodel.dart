import 'package:flutter/foundation.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/services/post_api_service.dart';
import 'package:share_your_skills/models/user.dart';

class PostViewModel extends ChangeNotifier {
  User? user;
  final PostApiService postApiService;

  PostViewModel(user) : postApiService = PostApiService(user) {
    print('PostViewModel initialized');
  }

  List<Post> _userAssignedPosts = [];
  List<Post> get userAssignedPosts => _userAssignedPosts;
  List<Post> _userPosts = [];
  List<Post> get userPosts => _userPosts;
  List<Post> _userPastPosts = [];
  List<Post> get userPastPosts => _userPastPosts;
  List<Post> _userCompletedPosts = [];
  List<Post> get userCompletedPosts => _userCompletedPosts;

  Future<void> fetchUserAssignedPosts() async {
    try {
      print("Fetch is called");
      final posts = await postApiService.getUserAssignedPosts();
      _userAssignedPosts.clear();
      _userAssignedPosts = posts;
      print('Updated userAssignedPosts length: ${_userAssignedPosts.length}');
      notifyListeners(); // Notify listeners when data changes
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      final posts = await postApiService.getPosts();
      _userPosts.clear();
      _userPosts = posts;

      notifyListeners(); // Notify listeners when data changes
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }

// add post
  Future<Post> addPost(Post post) async {
    try {
      print("PostViewModel - Add post is called");
      final createdpost = await postApiService.addPost(post);
      _userPosts.add(createdpost);
      notifyListeners();
      return createdpost;
    } catch (e) {
      print('Error adding post: $e');
      return post;
    }
  }
/*
  Future<String> fetchSkillIdByName(String name) async {
    try {
      final skillId = await postApiService.findSkillIdByName(name);
      return skillId;
    } catch (e) {
      print('Error fetching skill id: $e');
      throw 'Failed to fetch skill ID'; // Throw an exception on error
    }
  }
*/
  void clearAssignedPosts() {
    _userAssignedPosts.clear();
    _userPosts.clear();
    print('Clearing userAssignedPosts');
    print('userAssignedPosts cleared, length: ${_userAssignedPosts.length}');
    notifyListeners(); // Notify listeners when data changes
  }
}
