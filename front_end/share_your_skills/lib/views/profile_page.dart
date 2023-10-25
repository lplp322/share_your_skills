import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/components/select_user_skills.dart';
import 'package:share_your_skills/models/user.dart'; // Import your User model
import 'package:share_your_skills/viewmodels/skill_viewmodel.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:share_your_skills/views/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final skillViewModel = Provider.of<SkillViewModel>(context, listen: false);
    final User? user = userViewModel.user;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 30),
            HeaderProfile(
                name: user?.name ?? '',
                icon: Icons.portrait_rounded,
                fieldController: userViewModel.nameController),
            Field(
              fieldLabel: 'Email',
              fieldValue: user?.email ?? '',
              fieldController: userViewModel.emailController,
            ),
            Field(
                fieldLabel: 'City',
                fieldValue: user?.address?.city ?? '',
                fieldController: userViewModel.cityController),
            Field(
                fieldLabel: 'Street',
                fieldValue: user?.address?.street ?? '',
                fieldController: userViewModel.streetController),
            Field(
                fieldLabel: 'Street Number',
                fieldValue: user?.address?.houseNumber ?? '',
                fieldController: userViewModel.streetNoController),
            SizedBox(height: 40),
            SelectUserSkills(
                skillViewModel: skillViewModel, userViewModel: userViewModel),
            SizedBox(height: 130),
            EasyButton(
              type: EasyButtonType.elevated,  
              idleStateWidget: const Text(
                'Save Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              loadingStateWidget: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
              buttonColor: Color(0xFF588F2C),
              onPressed: () async {
                bool change = false;
                final futures = <Future>[];
                if (userViewModel.nameController.text != user?.name) {
                  change = true;
                  futures.add(userViewModel
                      .updateName(user!, userViewModel.nameController.text)
                      .then((_) {}));
                }
                if (userViewModel.emailController.text != user?.email) {
                  change = true;
                  futures.add(userViewModel
                      .updateEmail(user!, userViewModel.emailController.text)
                      .then((_) {}));
                }

                if (user?.address?.city != userViewModel.cityController.text ||
                    user?.address?.street !=
                        userViewModel.streetController.text ||
                    user?.address?.houseNumber !=
                        userViewModel.streetNoController.text) {
                  change = true;
                  // print('${user?.address?.city}-${userViewModel.cityController.text}');
                  // print('${user?.address?.street}-${userViewModel.streetController.text}');
                  // print('${user?.address?.houseNumber}-${userViewModel.streetNoController.text}');
                  final newAddress = Address(
                      city: userViewModel.cityController.text,
                      street: userViewModel.streetController.text,
                      houseNumber: userViewModel.streetNoController.text);
                  futures.add(userViewModel.updateAddress(user!, newAddress).then((_) {}));
                }
                await Future.wait(
                    futures); // Wait for async operations to complete

                if (change) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Changes saved successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 40),
            EasyButton(
              type: EasyButtonType.elevated,
              idleStateWidget: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              loadingStateWidget: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
               buttonColor: Color(0xFF588F2C),
              onPressed: () {
                userViewModel.logout(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  final String fieldValue;
  final String fieldLabel;
  final TextEditingController fieldController;

  Field(
      {required this.fieldValue,
      required this.fieldLabel,
      required this.fieldController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: fieldLabel,
        border: InputBorder.none,
        suffixIcon: Icon(
          Icons.add_circle_outline_sharp,
          size: 24, // Adjust the size as needed
        ),
      ),
      controller: fieldController, // Bind the controller to the TextField
    );
  }
}

class HeaderProfile extends StatelessWidget {
  final String name;
  final IconData icon;

  final TextEditingController fieldController;

  HeaderProfile(
      {required this.name, required this.icon, required this.fieldController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.portrait_rounded,
          size: 90,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              // labelText: "Name",
              labelStyle: TextStyle(fontSize: 20),
              hintText: 'Name',
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.add_circle_outline_sharp,
                size: 24, // Adjust the size as needed
              ),
            ),
            controller: fieldController, // Bind the controller to the TextField
          ),
        ),
      ],
    );
  }
}
