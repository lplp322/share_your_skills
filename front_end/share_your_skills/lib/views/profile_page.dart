import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/models/user.dart'; // Import your User model
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

    // Access user details from userViewModel.user
    final User? user = userViewModel.user;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text('Profile Page'),
          // Display user name
          Text('User Name: ${user?.name ?? ''}'),
          // Display user email
          Text('Email: ${user?.email ?? ''}'),
          // Display user skills (assuming it's a List<String>)
          Text('Skills: ${user?.skillIds?.join(', ') ?? ''}'),
          // Display user address (assuming it's an Address object)
          SizedBox(height: 10),
          if (user?.address != null) ...[
            Text('Address:'),
            SizedBox(height: 5),
            Text('City: ${user?.address?.city ?? ''}'),
            Text('Street: ${user?.address?.street ?? ''}'),
            Text('House Number: ${user?.address?.houseNumber ?? ''}'),
          ],
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
            
              userViewModel.logout(context); 
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
