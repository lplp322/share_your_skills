import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/services/post_api_service.dart';
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import '../models/skill.dart';
import '../services/skill_api_service.dart';

class SkillViewModel extends ChangeNotifier {
  User? _user;
  final SkillApiService skillApiService;
  final PostViewModel postViewModel;

  SkillViewModel(this._user, this.postViewModel)
      : skillApiService = _user != null
            ? SkillApiService(_user!.token)
            : SkillApiService('') {
    fetchSkillsOnce();
  } // Provide a default value or handle null case accordingly

  User? get user => _user;

  List<Skill> _skillList = [];
  List<Skill> get skillList => _skillList;

  Skill? _selectedSkill;
  Skill? get selectedSkill => _selectedSkill;

  void setSelectedSkill(Skill skill) {
    print(skill.name);
    if (_selectedSkill != skill) {
      _selectedSkill = skill;
      postViewModel.fetchPostsBySkill(skill.skillId);
      notifyListeners();
    }
  }

  void clearSelectedSkill() {
    if (_selectedSkill != null) {
      // Call the method from PostViewModel
      postViewModel.fetchRecommendedPosts(_user!);
      _selectedSkill = null;
      notifyListeners();
    }
  }

  // Add a method to fetch skills only once
  Future<void> fetchSkillsOnce() async {
    if (_skillList.isEmpty) {
      try {
        _user = user; // Update the user when fetching skills for a new user
        final skills = await skillApiService.getAllSkills();
        _skillList = skills;
        print('Fetched skills, total skills: ${_skillList.length}');
        notifyListeners();
      } catch (e) {
        print('Error fetching skills: $e');
      }
    }
  }

  Future<void> fetchSkills(User user) async {
    try {
      _user = user; // Update the user when fetching posts for a new user
      final skills = await skillApiService.getAllSkills();
      _skillList = skills;
      print('Updated skills length: ${_skillList.length}');
      notifyListeners();
    } catch (e) {
      print('Error fetching user assigned posts: $e');
    }
  }
}
