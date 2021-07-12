import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final PersonalizedUser currentUser;

  const SettingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final PersonalizedUser _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: settingsBody(),
    );
  }

  Widget settingsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'General',
              style: TextStyle(color: Colors.grey[800], fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Allow Push Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    primary: Colors.white),
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                )),
          )
        ],
      ),
    );
  }
}
