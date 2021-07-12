import 'dart:io';

import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/data_storage/storage.dart';
import 'package:firebase_chat_app/home/account_details_page.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/settings_page.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const String route = 'profile';

  PersonalizedUser currentUser;

  ProfilePage(this.currentUser);

  @override
  _ProfilePageState createState() =>
      _ProfilePageState(currentUser: currentUser);
}

class _ProfilePageState extends State<ProfilePage> {
  PersonalizedUser currentUser;

  _ProfilePageState({required this.currentUser});

  // Image picked by user
  File? _image;

  // Image picker
  final picker = ImagePicker();

  Future _getImageAndUpdate() async {
    // print('Open gallery');
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      // Start a loading dialog
      AuthTools.showLoaderDialog(context);

      // Update the users image if it isn't null
      await Storage().updateImageToFirebase(currentUser, _image!);

      // Acess Storage for the users profile pic and add it to the instance if it exists, otherwise make it null
      currentUser.profilePicDownloadUrl =
          await Storage().getImageFromFirebase(currentUser.uid);

      // Update in the database
      await DatabaseTools().updateUser(currentUser);

      // Stop the loading dialog
      Navigator.pop(context);

      setState(() {
        currentUser = currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(currentUser.profilePicDownloadUrl);

    return HomeScaffold(
        key: UniqueKey(),
        user: currentUser,
        title: 'Profile',
        home: _profileHome(),
        drawerSelection: DrawerSelection.profile);
  }

  Widget _profileHome() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  // On tap is going to prompt user to choose new profile pick
                  onTap: _getImageAndUpdate,
                  child: Stack(clipBehavior: Clip.hardEdge, children: [
                    getUserCircleAvatar(currentUser, 50),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          height: 35,
                          width: 35,
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          )),
                    )
                  ]),
                ),
                SizedBox(height: 20),
                Text(
                  '${currentUser.firstName} ${currentUser.lastName}',
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Account Details')
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          AccountDetailsPage(currentUser: currentUser)));
            },
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Settings')
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          SettingsPage(currentUser: currentUser)));
            },
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Contact Us')
                ],
              ),
            ),
            onTap: () {},
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 100)),
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
