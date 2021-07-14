import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/searching_page_widget.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactsPage extends StatefulWidget {
  static const String route = '/contacts';
  final currentUser;

  ContactsPage(this.currentUser);

  @override
  _ContactsPageState createState() => _ContactsPageState(currentUser);
}

class _ContactsPageState extends State<ContactsPage> {
  final PersonalizedUser currentUser;

  _ContactsPageState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseTools().getUserStream(currentUser.uid),
        builder: (ctx, snapshot) {
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

            return HomeScaffold(
                key: UniqueKey(),
                user: updatedUser,
                title: 'Contacts',
                home: SearchBody(
                  currentUser: updatedUser,
                  typePage: ChatApp.SEARCHING_FRIENDS_PAGE,
                ),
                drawerSelection: DrawerSelection.contacts);
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
}
