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
  /*
  final Map<String, String> skillNameToId = {
    "Cleaning": "652e223fbf0dea6755b2198b",
    "Cooking": "652e2246bf0dea6755b2198d",
    "Gardening": "652e224cbf0dea6755b2198f",
    // Add more skills and their corresponding IDs here
  };*/
  List<String> predefinedSkills = [];
  Map<String, String> skillIdToName = {};

  @override
  void initState() {
    super.initState();
    _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final skills = await userViewModel.fetchSkills();
     print("Skills: $skills");
    setState(() {
      predefinedSkills = skills.keys.toList();
      skillIdToName = skills;
    });
  }

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
                Text("Select skills:"),
                Row(
                  children: predefinedSkills.map((skill) {
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedSkills.contains(skill),
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  selectedSkills.add(skill);
                                } else {
                                  selectedSkills.remove(skill);
                                }
                              });
                            }
                          },
                        ),
                        Text(skillIdToName[skill] ?? skill),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final List<String> userSkills = selectedSkills
                        .map((skillName) {
                          final skillId = skillName;
                          return skillId;
                        })
                        .whereType<
                            String>() // Filter out null values and cast to List<String>
                        .toList();

                    // Check if the user has selected at least one skill
                    if (userSkills.isEmpty) {
                      print("Please select at least one skill.");
                      return;
                    }
                    print("User Skills: $userSkills");
                    // Perform user registration with skill IDs
                    userViewModel.registerUser(
                      fullName: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      selectedSkills: userSkills,
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
                            errorMessage,
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
