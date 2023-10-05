import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:share_your_skills/views/login_page.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 // Get the UserViewModel instance

  @override
  Widget build(BuildContext context) {
     final userViewModel =
        Provider.of<UserViewModel>(context); 
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text('Profile Page'),
          //display user name and user id from userViewModel
          Text('User Name: ${userViewModel.user?.name}'), 
          SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () {
                  // Logout logic
                  userViewModel.logout(); // Implement this method in UserViewModel
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Logout'),
              ),
        ],
        ),
    );
  }
}