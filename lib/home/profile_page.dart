import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String route = 'profile';

  final user;

  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState(this.user);
}

class _ProfilePageState extends State<ProfilePage> {
  final user;

  _ProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        user, 'Profile', _profileHome(), DrawerSelection.profile);
  }

  Widget _profileHome() {
    return Container();
  }
}
