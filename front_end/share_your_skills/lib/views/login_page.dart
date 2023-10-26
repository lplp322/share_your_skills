import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:share_your_skills/viewmodels/user_viewmodel.dart'; // Import your UserViewModel
import 'package:share_your_skills/views/registration.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: true);
    errorMessage = userViewModel.errorMessage;

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login Page',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Username",
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // wrap the errormassage in a consumer to lsiten the changes of userviewmodel
                Consumer<UserViewModel>(
                  builder: (context, userViewModel, _) {
                    return errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red,
                            ), // Display error in red text
                          )
                        : SizedBox();
                  },
                ),

                EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: const Text(
                    'Login',
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
                  width: 200.0,
                  height: 40.0,
                  borderRadius: 4.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: Color(0xFF588F2C),
                  onPressed: () async {
                    try {
                      await userViewModel.loginUser(
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                    } catch (e) {}
                  },
                ),

                SizedBox(
                  height: 20,
                ),
                // display text "dont have an account? register here"
                Text(
                  "Don't have an account? Register now",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      userViewModel.errorMessage = null;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                  loadingStateWidget: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  width: 200.0,
                  height: 40.0,
                  borderRadius: 4.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: Color(0xFF588F2C),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
