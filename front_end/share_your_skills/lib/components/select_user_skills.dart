import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:share_your_skills/components/filter_skills.dart';
import 'package:share_your_skills/models/skill.dart';
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/viewmodels/skill_viewmodel.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';

class SelectUserSkills extends StatelessWidget {
  const SelectUserSkills(
      {super.key, required this.skillViewModel, required this.userViewModel});

  final SkillViewModel skillViewModel;
  final UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    User? user = userViewModel.user;
    List<String>? userSkillIds = user?.skillIds;

    List<Skill> initialSelectedSkills = userSkillIds?.map((skillId) {
          return skillViewModel.skillList
              .firstWhere((skill) => skill.skillId == skillId);
        }).toList() ??
        [];
    List<MultiSelectItem<Skill>> multiSelectSkills = skillViewModel.skillList
        .map((skill) => MultiSelectItem<Skill>(skill, skill.name))
        .toList();
    return MultiSelectDialogField(
      items: multiSelectSkills,
      buttonText: Text("Select your skills"),
      listType: MultiSelectListType.CHIP,
      initialValue: initialSelectedSkills,
      chipDisplay: MultiSelectChipDisplay(
        icon: Icon(Icons.accessibility),
      ),
      onConfirm: (values) {
        List<String> updatedListSkills = values.map((skill) => skill.skillId as String).toList();
        if (user != null) {
          userViewModel.updateSkills(user, updatedListSkills);
        }
      },
    );
  }
}