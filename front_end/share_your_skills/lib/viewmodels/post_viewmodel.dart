import 'package:flutter/foundation.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/services/post_api_service.dart';
import 'package:share_your_skills/models/user.dart';

class PostViewModel extends ChangeNotifier {
  final User? user;
  final PostApiService postApiService; // Not nullable

  PostViewModel(this.user) : postApiService = PostApiService(user!.token);

  List<Post> _userAssignedPosts = [];
  List<Post> get userAssignedPosts => _userAssignedPosts;

  Future<void> fetchUserAssignedPosts() async {
    try {
      final posts = await postApiService.getUserAssignedPosts(user!.userId!);
      _userAssignedPosts = posts;
      print('Updated userAssignedPosts length: ${_userAssignedPosts.length}');
      notifyListeners();
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }
  void clearAssignedPosts() {
    _userAssignedPosts.clear();
    notifyListeners();
  }
}
