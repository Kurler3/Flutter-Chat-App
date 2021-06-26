import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/home/conversations_page.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = "/conversations";
  final User _user;

  HomePage(this._user);

  @override
  _HomePageState createState() => _HomePageState(_user.uid);
}

class _HomePageState extends State<HomePage> {
  final String _userID;

  _HomePageState(this._userID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersonalizedUser>(
        future: DatabaseTools().getUser(_userID),
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final personalizedUser = snapshot.data!;

              return _home(personalizedUser);
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            ),
          );
        });
  }

  Widget _home(PersonalizedUser personalizedUser) {
    return ConversationsPage(personalizedUser);
  }
}
