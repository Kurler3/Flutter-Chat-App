import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text(_user.email.toString()),
        ),
      ),
    );
  }
}
