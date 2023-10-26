import 'package:flutter/foundation.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/services/post_api_service.dart';
import 'package:share_your_skills/models/user.dart';

class PostViewModel extends ChangeNotifier {
  User? user;
  final PostApiService postApiService;

  PostViewModel(user) : postApiService = PostApiService(user) {
    fetchRecommendedPosts();
  }

  List<Post> _userAssignedPosts = [];
  List<Post> get userAssignedPosts => _userAssignedPosts;

  List<Post> _displayPosts = [];
  List<Post> get displayPosts => _displayPosts;

    List<Post> _userPosts = [];
  List<Post> get userPosts => _userPosts;
  List<Post> _userPastPosts = [];
  List<Post> get userPastPosts => _userPastPosts;
  List<Post> _userCompletedPosts = [];
  List<Post> get userCompletedPosts => _userCompletedPosts;

  set displayPosts(List<Post> new_displayPosts){
    _displayPosts = new_displayPosts;
  }
  Future<void> fetchUserAssignedPosts() async {
    try {
      print("Fetch is called");
      final posts = await postApiService.getUserAssignedPosts();
      _userAssignedPosts.clear();
      _userAssignedPosts = posts;
      print('Updated userAssignedPosts length: ${_userAssignedPosts.length}');
      notifyListeners(); 
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  } 
  void fetchAllPosts() {
    fetchUserAssignedPosts();
    fetchUserPosts();
    fetchUserPastPosts();
    fetchUserCompletedPosts();
    fetchRecommendedPosts();
  }

  // fetch user posts
  Future<void> fetchUserPosts() async {
    try {
      final posts = await postApiService.getPosts();
      _userPosts.clear();
      _userPosts = posts;

      notifyListeners(); 
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }
  // fetch user past posts
  Future<void> fetchUserPastPosts() async {
    try {
      final posts = await postApiService.getMyPastPosts();
      _userPastPosts.clear();
      _userPastPosts = posts;

      notifyListeners(); 
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }

  // fetch user completed posts
  Future<void> fetchUserCompletedPosts() async {
    try {
      final posts = await postApiService.getUserPastAssignedPosts();
      _userCompletedPosts.clear();
      _userCompletedPosts = posts;

      notifyListeners(); 
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
  // call update post
  Future<Post> updatePost(Post post) async {
    try {
      print("PostViewModel - Update post is called");
      final updatedpost = await postApiService.updatePost(post);
      _userPosts.removeWhere((post) => post.id == updatedpost.id);
      _userPosts.add(updatedpost);
      notifyListeners();
      return updatedpost;
    } catch (e) {
      print('Error updating post: $e');
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
      throw 'Failed to fetch skill ID'; 
    }
  }
*/

  Future<List<Post>> fetchRecommendedPosts() async {
    try {
      final posts = await postApiService.getRecommendedPosts();
      _displayPosts = posts;
      print('Updated fetch recommended posts length: ${_displayPosts.length}');
      notifyListeners();
      return _displayPosts;
    } catch (e) {
      print('Error fetching recommended posts: $e');
      return _displayPosts;
    }
  }

  Future<List<Post>> fetchPostsBySkill(String skillId) async {
    try {
      print('postbySkillID-${skillId}');
      final posts = await postApiService.getPostsBySkill(skillId);
      _displayPosts = posts;
      print('Updated posts by skill length: ${_displayPosts.length}');
      notifyListeners();
      return _displayPosts;
    } catch (e) {
      print('Error fetching recommended posts: $e');
      return _displayPosts;
    }
  }

  Future<void> assignPost(String postId) async{
    // http://localhost:8000/posts/assignPost
    try {
      final posts = await postApiService.assignPost(postId);
      print('Assigned post succesfully');
      notifyListeners();
    } catch (e) {
      print('Error fetching recommended posts: $e');
    }
  }



  void clearAssignedPosts() {
    _userAssignedPosts.clear();
    _userPosts.clear();
    _userPastPosts.clear();
    _userCompletedPosts.clear();
    
    notifyListeners();
  }
  // call post delete
  Future<void> deletePost(String postId) async {
    try {
      await postApiService.deletePost(postId);
      _userPosts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
  // call get user name by id
  /*
  Future<String> getUserNameById(String userId) async {
    try {
      print("PostViewModel - getUserNameById is called");
      final userName = await postApiService.getUserNameById(userId);
      return userName;
    } catch (e) {
      print('Error fetching user name: $e');
      throw 'Failed to fetch user name';
    }
  }*/
}
