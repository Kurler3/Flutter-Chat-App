import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/data_storage/storage.dart';
import 'package:firebase_chat_app/home/account_details_page.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/profile_interface.dart';
import 'package:firebase_chat_app/home/settings_page.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const String route = 'profile';

  final PersonalizedUser currentUser;

  ProfilePage(this.currentUser);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    implements OnProfileDetailsChange {
  late PersonalizedUser currentUser;

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

      setState(() {
        currentUser = currentUser;
      });

      // Stop the loading dialog
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    if (oldWidget.currentUser.profilePicDownloadUrl !=
        widget.currentUser.profilePicDownloadUrl) {
      currentUser = widget.currentUser;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseTools().getUserStream(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            PersonalizedUser updatedUser = PersonalizedUser.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);

            print(updatedUser.firstName);

            return HomeScaffold(
                key: UniqueKey(),
                user: updatedUser,
                title: 'Profile',
                home: ProfilePageHome(
                  key: UniqueKey(),
                  currentUser: updatedUser,
                  getImageAndUpdate: _getImageAndUpdate,
                ),
                drawerSelection: DrawerSelection.profile);
          }

          return Scaffold(
            body: Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        });
  }

  @override
  void updatedCurrentUser(PersonalizedUser updatedCurrentUser) {
    // TODO: implement updatedCurrentUser
  }
}

class ProfilePageHome extends StatefulWidget {
  final PersonalizedUser currentUser;
  Function() getImageAndUpdate;

  ProfilePageHome(
      {Key? key, required this.currentUser, required this.getImageAndUpdate})
      : super(key: key);

  @override
  _ProfilePageHomeState createState() => _ProfilePageHomeState();
}

class _ProfilePageHomeState extends State<ProfilePageHome> {
  late PersonalizedUser currentUser;
  late Function() getImageAndUpdate;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    getImageAndUpdate = widget.getImageAndUpdate;
  }

  @override
  void didUpdateWidget(covariant ProfilePageHome oldWidget) {
    if (currentUser != widget.currentUser) {
      setState(() {
        currentUser = widget.currentUser;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: getImageAndUpdate,
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
    ;
  }
}
