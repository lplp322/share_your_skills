import 'package:flutter/foundation.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/services/post_api_service.dart';
import 'package:share_your_skills/models/user.dart';

class PostViewModel extends ChangeNotifier {
  User? _user;
  final PostApiService postApiService;

  PostViewModel(this._user) : postApiService = _user != null ? PostApiService(_user!.token) : PostApiService(''); // Provide a default value or handle null case accordingly


  User? get user => _user;

  List<Post> _userAssignedPosts = [];
  List<Post> get userAssignedPosts => _userAssignedPosts;

  Future<void> fetchUserAssignedPosts(User user) async {
    try {
      _user = user; // Update the user when fetching posts for a new user
      final posts = await postApiService.getUserAssignedPosts(user.userId!);
      _userAssignedPosts = posts;
      print('Updated userAssignedPosts length: ${_userAssignedPosts.length}');
      notifyListeners();
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }

  void clearAssignedPosts() {
    if (_user != null) {
      _userAssignedPosts.clear();
      print('Clearing userAssignedPosts');
      print('userAssignedPosts cleared, length: ${_userAssignedPosts.length}');
      notifyListeners();
    }
  }
}
