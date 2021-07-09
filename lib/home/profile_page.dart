import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  static const String route = 'profile';

  final PersonalizedUser currentUser;

  ProfilePage(this.currentUser);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late PersonalizedUser _currentUser;

  @override
  void initState() {
    super.initState();

    _currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        _currentUser, 'Profile', _profileHome(), DrawerSelection.profile);
  }

  Widget _profileHome() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getUserCircleAvatar(_currentUser, 30),
              Text(
                '${_currentUser.firstName} ${_currentUser.lastName}',
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Account Details')
                ],
              ),
              onTap: () {},
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Settings')
                ],
              ),
              onTap: () {},
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Contact Us')
                ],
              ),
              onTap: () {},
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Logout"))
        ],
      ),
    );
  }
}
