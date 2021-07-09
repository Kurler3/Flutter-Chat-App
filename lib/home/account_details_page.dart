import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';

class AccountDetailsPage extends StatefulWidget {
  final PersonalizedUser currentUser;

  const AccountDetailsPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late PersonalizedUser _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true,
      ),
      body: accountDetailsBody(),
    );
  }

  Widget accountDetailsBody() {
    return Container();
  }
}
