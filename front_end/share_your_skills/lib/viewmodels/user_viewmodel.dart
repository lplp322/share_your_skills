import 'package:flutter/material.dart';
import 'package:share_your_skills/models/user.dart';
import 'package:share_your_skills/services/user_api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_your_skills/views/login_page.dart';
class UserViewModel extends ChangeNotifier {
  User? _user;
  String? registrationErrorMessage;
  String? loginErrorMessage;
  final UserApiService _userApiService;
  final BuildContext context;
  String? errorMessage; // Common error message for both login and registration
  late SharedPreferences _prefs;

  UserViewModel(this._userApiService, this.context) {
    initSharedPrefs();
  }

  User? get user => _user;

  Future<void> initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> registerUser(
      String fullName, String email, String password) async {
    try {
      final registeredUser = await _userApiService.registerUser(
        fullName,
        email,
        password,
      );

      if (registeredUser != null) {
        _user = registeredUser;
        registrationErrorMessage = null;
      } else {
        registrationErrorMessage = 'Registration failed. Please try again.';
      }
    } catch (e) {
      registrationErrorMessage = 'Registration failed. Please try again.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final loggedInUser = await _userApiService.loginUser(email, password);

      if (loggedInUser != null) {
        final token = loggedInUser.token;

        if (!JwtDecoder.isExpired(token)) {
          _user = loggedInUser;
          loginErrorMessage = null;
        } else {
          loginErrorMessage = 'Token is expired. Please log in again.';
          _prefs.remove('token'); // Clear token from shared preferences
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

  void logoutUser() {
    _user = null;
    _prefs.remove('token'); // Clear token from shared preferences
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
