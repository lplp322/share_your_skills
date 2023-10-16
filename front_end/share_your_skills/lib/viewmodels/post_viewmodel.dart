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

  void clearAssignedPosts() {
    _userAssignedPosts.clear();
    print('Clearing userAssignedPosts');
    print('userAssignedPosts cleared, length: ${_userAssignedPosts.length}');
    notifyListeners(); // Notify listeners when data changes
  }
}
