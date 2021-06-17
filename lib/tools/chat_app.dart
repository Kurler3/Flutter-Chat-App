import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatApp {
  static const String app_name = "Chatty";
  static const String app_version = "Version 1.0.4";
  static const int app_version_code = 1;
  static const String app_color = "#ffd7167";
  static Color primaryAppColor = Colors.blue;
  static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "GoogleSans";
  static bool isDebugMode = false;

  // Preferences
  static late SharedPreferences prefs;
  static const String DARK_MODE_PREF = 'darkModePref';

  // Auth
  static const String SIGN_IN_SUCCESSFUL = "SIGN_IN";
  static const String SIGN_OUT_SUCCESSFUL = "SIGN_OUT";
  static const String SIGN_UP_SUCCESSFUL = "SIGN_UP";
  static const String LOGIN_FAILED_TITLE = "Login failed";
  static const String LOGIN_FAILED_MESSAGE =
      "Inputted data incorrect. Try again!";
  static const String LOGOUT_FAILED_MESSAGE =
      "Couldn't logout. Try again, please!";
  static const String SIGN_UP_FAILED_MESSAGE =
      "Couldn't create account. Please try again";
  static const String SIGN_UP_SUCCESS_MESSAGE = "Account created successfully!";

  // Register page text fields
  // static const String REGISTER_FIRST_NAME = "REGISTER_FIRST_NAME";
  // static const String REGISTER_LAST_NAME = "REGISTER_LAST_NAME";
  // static const String REGISTER_PHONE_NUMBER = "REGISTER_PHONE_NUMBER";
  // static const String REGISTER_EMAIL = "REGISTER_EMAIL";
  // static const String REGISTER_PASSWORD = "REGISTER_PASSWORD";
  // static const String REGISTER_CONFIRM_PASSWORD = "REGISTER_CONFIRM_PASSWORD";

  // Register Page label and hint texts
  static const String REGISTER_FIRST_NAME_LABEL = "First Name";
  static const String REGISTER_FIRST_NAME_HINT = "Enter your first name";
  static const String REGISTER_LAST_NAME_LABEL = "Last Name";
  static const String REGISTER_LAST_NAME_HINT = "Enter your last name";
  static const String REGISTER_PHONE_NUMBER_LABEL = "Mobile Number";
  static const String REGISTER_PHONE_NUMBER_HINT = "Enter your mobile number";
  static const String REGISTER_EMAIL_LABEL = "Email";
  static const String REGISTER_EMAIL_HINT = "Enter your email";
  static const String REGISTER_PASSWORD_LABEL = "Password";
  static const String REGISTER_PASSWORD_HINT = "Enter your password";
  static const String REGISTER_CONFIRM_PASSWORD_LABEL = "Confirm Password";
  static const String REGISTER_CONFIRM_PASSWORD_HINT =
      "Enter your password again";
  static const String REGISTER_SUCCESSFUL_ADDED_USER_DATABASE =
      "REGISTER_SUCCESSFUL_ADDED_USER_DATABASE";

  // Colors
  static List AVATAR_BACKGROUND_COLORS = [
    Colors.red,
    Colors.amber,
    Colors.brown[400]
  ];
}
