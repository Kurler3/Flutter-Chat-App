import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
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

  _HomePageState(this._user);

  @override
  Widget build(BuildContext context) {
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
