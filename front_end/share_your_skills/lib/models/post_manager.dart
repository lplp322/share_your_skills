import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:share_your_skills/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
class PostViewModelManager extends ChangeNotifier{
  Map<User, PostViewModel> userPostViewModels = {};

  PostViewModel onUserLogin(User user) {
    // Create a new PostViewModel instance for the user
    final postViewModel = PostViewModel(user);
    userPostViewModels[user] = postViewModel;
    return postViewModel;
  }

  void onUserLogout(User user) {
    // Dispose of the user's PostViewModel instance
    userPostViewModels.remove(user);
  }
}
