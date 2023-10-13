import 'package:flutter/material.dart';
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/services/user_api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_your_skills/views/login_page.dart';
import 'package:share_your_skills/views/app_bar.dart' as MyAppbar;
import 'package:provider/provider.dart';
import 'package:share_your_skills/models/app_state.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  String? registrationErrorMessage;
  String? loginErrorMessage;
  final UserApiService _userApiService;
  final BuildContext context;
  late SharedPreferences _prefs;

  UserViewModel(this._userApiService, this.context) {
    initSharedPrefs();
  }

  User? get user => _user;

  Future<void> initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required List<String> selectedSkills,
    required String city,
    required String street,
    required String houseNumber,
    BuildContext? context,
  }) async {
    try {
      if (fullName.isEmpty) {
        registrationErrorMessage = 'Please enter your Fullname.';
      } else if (email.isEmpty) {
        registrationErrorMessage = 'Please enter your Email.';
      } else if (password.isEmpty) {
        registrationErrorMessage = 'Please enter your Password.';
      } else {
        final user = User(
          name: fullName,
          email: email,
          skillIds: selectedSkills, // Use the skill IDs here
          address: Address(
            city: city,
            street: street,
            houseNumber: houseNumber,
          ),
        );

        final registeredUser =
            await _userApiService.registerUser(user, password);

        if (registeredUser != null) {
          final token = registeredUser.token;

          if (!JwtDecoder.isExpired(token)) {
            _user = registeredUser;
            registrationErrorMessage = null;
            _prefs.setString('token', token);

            if (context != null) {
              Provider.of<AppState>(context, listen: false).setSelectedIndex(2);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyAppbar.AppBar(
                    token: token,
                  ),
                ),
              );
            }
          } else {
            print('Token is expired. Token data: ${JwtDecoder.decode(token)}');
            registrationErrorMessage = 'Token is expired. Please log in again.';
            _prefs.remove('token');
          }
        } else {
          registrationErrorMessage = 'Registration failed. Please try again.';
        }
      }
    } catch (e) {
      print('Registration error: $e');
      registrationErrorMessage = 'Registration failed. Please try again.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final loggedInUser = await _userApiService.loginUser(email, password);

      if (loggedInUser != null) {
        final token = loggedInUser.token;

        if (!JwtDecoder.isExpired(token)) {
          _user = loggedInUser;
          loginErrorMessage = null;

          final postViewModel =
              Provider.of<PostViewModel>(context, listen: false);
          await postViewModel.fetchUserAssignedPosts();

          print('Navigator context: $context');
          Provider.of<AppState>(context, listen: false).setSelectedIndex(2);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => MyAppbar.AppBar(
                      token: token,
                    )),
          );
        } else {
          print('Token is expired. Token data: ${JwtDecoder.decode(token)}');
          loginErrorMessage = 'Token is expired. Please log in again.';
          _prefs.remove('token');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        loginErrorMessage = 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      loginErrorMessage = 'Login failed. Please check your credentials.';
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _prefs.remove('token');
/*
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    if (postViewModel.userAssignedPosts.isNotEmpty) {
         postViewModel.clearAssignedPosts();
    }*/

    notifyListeners();
  }
}
