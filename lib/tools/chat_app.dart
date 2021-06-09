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
}
