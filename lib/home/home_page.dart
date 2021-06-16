import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = "/home";
  final User _user;

  HomePage(this._user);

  @override
  _HomePageState createState() => _HomePageState(_user);
}

class _HomePageState extends State<HomePage> {
  final User _user;
  late final PersonalizedUser? _personalizedUser;

  _HomePageState(this._user);

  @override
  void initState() async {
    super.initState();

    // Search for PersonalizedUser in the database
    _personalizedUser = await DatabaseTools().getUser(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    // If _personalizedUser is null then it wasn't found in the database, which means there's an error.
    // Display an error dialog, wait for 2 seconds and log the user out

    AuthenticationService _authService = context.read<AuthenticationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(ChatApp.app_name),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text('Logout'),
            onPressed: () async {
              // Output loading circle
              AuthTools.showLoaderDialog(context);
              // Sign out
              String res = await _authService.signOut();
              // Remove loading circle
              Navigator.pop(context);
              // Output alert saying it wasn't possible if err
              if (res != ChatApp.SIGN_OUT_SUCCESSFUL) {
                ScaffoldMessenger.of(context).showSnackBar(
                    AuthTools.errorSnackBar(ChatApp.LOGOUT_FAILED_MESSAGE));
              }
            },
          ),
        ),
      ),
    );
  }
}
