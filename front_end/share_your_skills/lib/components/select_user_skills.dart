import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
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
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        User? user = userViewModel.user;
        List<String>? userSkillIds = user?.skillIds;
        List<Skill> initialSelectedSkills = userSkillIds?.map((skillId) {
          return skillViewModel.skillList
              .firstWhere((skill) => skill.skillId == skillId,
                  orElse: () => Skill(skillId: '', name: ''),
              );
        }).toList() ??
            [];
        List<MultiSelectItem<Skill>> multiSelectSkills = skillViewModel.skillList
            .map((skill) => MultiSelectItem<Skill>(skill, skill.name))
            .toList();
        // print('initial-${initialSelectedSkills}');
        // for (var element in initialSelectedSkills) {
        //   print('element-${element.name}');
        // }
        // print('users-${userSkillIds}');
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
            List<Skill> valuesAsSkill = values.map((skill) => skill as Skill).toList(); // Convert to List<Skill>
            if (user != null) {
              userViewModel.updateSkills(user, updatedListSkills);
            }
          },
        );
      },
    );
  }
}