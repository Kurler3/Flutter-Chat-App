import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FireBase
  await Firebase.initializeApp();

  // Get the prefs
  ChatApp.prefs = await SharedPreferences.getInstance();

  runApp(ConfigPage());
}
