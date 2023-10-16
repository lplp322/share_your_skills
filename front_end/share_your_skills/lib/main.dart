import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/login_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:share_your_skills/models/app_state.dart';
import 'package:share_your_skills/services/user_api_service.dart';
import 'package:share_your_skills/views/app_bar.dart' as MyAppbar;
import 'package:share_your_skills/models/post_manager.dart';
void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserApiService>(
          create: (context) => UserApiService('http://localhost:8000/users'),
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(
            Provider.of<UserApiService>(context, listen: false),
            context,
          ),
        ),
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider<PostViewModelManager>(
          create: (context) => PostViewModelManager(),
        ),
      ],
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<UserViewModel>(
          builder: (context, userViewModel, _) {
            if (userViewModel.user != null) {
              return MyAppbar.AppBar(
                token: userViewModel.user?.token,
              );
            } else {
              return LoginPage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
