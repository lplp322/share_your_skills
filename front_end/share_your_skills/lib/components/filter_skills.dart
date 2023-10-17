import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/models/skill.dart';
import 'package:share_your_skills/viewmodels/skill_viewmodel.dart';
import '../viewmodels/post_viewmodel.dart';

class ButtonData {
  final String label;
  final IconData icon;

  ButtonData({required this.label, required this.icon});
}

class FilterComponent extends StatelessWidget {
  final SkillViewModel skillViewModel;
  final PostViewModel postViewModel;

  FilterComponent({
    required this.skillViewModel,
    required this.postViewModel
  });

  @override
  Widget build(BuildContext context) {
      return Selector<SkillViewModel, List<Skill>>(
      selector: (context, skillViewModel) => skillViewModel.skillList,
      builder: (context, skills, child) {
        if (skills.isEmpty) {
          return CircularProgressIndicator(); // Show loading indicator while fetching
        } else {
          return FilterSkillsList(skills: skills);
        }
      },
    );
  }
}

class FilterSkillsList extends StatelessWidget {
  final List<Skill> skills;

  FilterSkillsList({
    required this.skills,
  });

  // Mapping of skils with icons
  final List<ButtonData> buttonDataList = [
    ButtonData(
      label: 'Recommended',
      icon: Icons.favorite_rounded,
    ),
    ButtonData(
      label: 'Gardening',
      icon: Icons.yard_rounded,
    ),
    ButtonData(
      label: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
    ),
    ButtonData(
      label: 'Plumming',
      icon: Icons.plumbing_rounded,
    ),
    ButtonData(
      label: 'Carpenter',
      icon: Icons.carpenter_rounded,
    ),
    ButtonData(
      label: 'Pets',
      icon: Icons.pets_outlined,
    ),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillViewModel>(builder: (context, skillViewModel, child) {
      return Container(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // buttonDataList.map((data) {
            //   return Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: FilterSkillButton(
            //       label: data.label,
            //       icon: data.icon,
            //     ),
            //   );
            // }).toList(),
            // Recommended Button
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
              child: FilterSkillButton(
                label: "Recommended",
                icon: Icons.favorite_rounded,
                isSelected: skillViewModel.selectedSkill == null,
                onTap: () {
                  skillViewModel.clearSelectedSkill();
                },
              ),
            ),
            // Rest of skills
            ...skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterSkillButton(
                  label: skill.name,
                  icon: getSkillIcon(skill.name),
                  isSelected: skillViewModel.selectedSkill == skill,
                  onTap: () {
                    skillViewModel.setSelectedSkill(skill);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}

IconData getSkillIcon(String iconName){
    IconData icon;
    switch (iconName) {
    case "tennis":
      icon = Icons.sports_tennis_rounded;
      break;
    case "cleaning":
      icon = Icons.cleaning_services_rounded;
      break;
    case "Gardening":
      icon = Icons.yard_rounded;
      break;
    case "Cleaning":
      icon = Icons.cleaning_services_rounded;
      break;
    case "Cooking":
      icon = Icons.cookie_rounded;
      break;
    // Add more cases for other icon names as needed
    default:
      icon = Icons.broken_image_rounded; // Use a default icon for unknown names
  }
    return icon;
  }

class FilterSkillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Function()? onTap;

  FilterSkillButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Color(0xFFE9EEF5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide.none
        ),
      ),
      onPressed: onTap,
      child: Icon(
        icon,
        color: isSelected ? Colors.green : Colors.grey,
      ),
    );
  }
}
