import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

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
  String? errorMessage;
  String? localErrorMessage;
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
    errorMessage = userViewModel.errorMessage;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF588F2C),
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
                EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: const Text(
                    'Register',
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
                  width: 150.0,
                  height: 40.0,
                  borderRadius: 4.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: Color(0xFF588F2C),
                  onPressed: () async {
                    final List<String> userSkills = selectedSkills
                        .map((skillName) => skillName)
                        .whereType<String>()
                        .toList();

                    if (userSkills.isEmpty) {
                      setState(() {
                        localErrorMessage = "Please select at least one skill.";
                      });

                      return;
                    }

                    try {
                      await userViewModel.registerUser(
                        fullName: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        selectedSkills: userSkills,
                        city: cityController.text,
                        street: streetController.text,
                        houseNumber: houseNumberController.text,
                        context: context,
                      );
                    } catch (e) {
                      setState(() {
                        localErrorMessage = e.toString();
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                Consumer<UserViewModel>(
                  builder: (context, userViewModel, _) {
                    final combinedErrorMessage =
                        errorMessage ?? localErrorMessage;
                    return combinedErrorMessage != null
                        ? Text(
                            combinedErrorMessage,
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
