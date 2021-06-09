import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the prefs
  ChatApp.prefs = await SharedPreferences.getInstance();

  runApp(ConfigPage());
}
