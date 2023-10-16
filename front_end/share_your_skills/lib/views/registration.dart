import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  List<String> selectedSkills = [];
  final Map<String, String> skillNameToId = {
    "Cleaning": "65256b8601db3b3814171c5f",
    "Cooking": "65256b7101db3b3814171c5b",
    "Gardening": "65256b7a01db3b3814171c5d",
    // Add more skills and their corresponding IDs here
  };

  List<String> predefinedSkills = [
    "Cleaning",
    "Cooking",
    "Gardening",
  ];
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: true);
    String? errorMessage = userViewModel.registrationErrorMessage;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: streetController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Street",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: houseNumberController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "House Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Select up to 3 skills:"),
                Row(
                  children: predefinedSkills.map((skill) {
                    final skillId =
                        skillNameToId[skill] ?? ''; // Get the ID from the map
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedSkills.contains(skillId),
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  if (selectedSkills.length < 3) {
                                    selectedSkills.add(skillId);
                                  }
                                } else {
                                  selectedSkills.remove(skillId);
                                }
                              });
                            }
                          },
                        ),
                        Text(skill),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    userViewModel.registerUser(
                      fullName: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      selectedSkills: selectedSkills,
                      city: cityController.text,
                      street: streetController.text,
                      houseNumber: houseNumberController.text,
                      context: context,
                    );
                  },
                  child: Text('Register'),
                ),
                SizedBox(height: 10),
                Consumer<UserViewModel>(
                  builder: (context, userViewModel, _) {
                    return errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
