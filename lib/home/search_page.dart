import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/searching_page_widget.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchPage extends StatefulWidget {
  static const String route = '/search';

  final user;

  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState(this.user);
}

class _SearchPageState extends State<SearchPage> {
  final currentLoggedUser;

  _SearchPageState(this.currentLoggedUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseTools().getUserStream(currentLoggedUser.uid),
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
                title: 'Search',
                home: SearchBody(
                  currentUser: updatedUser,
                  typePage: ChatApp.SEARCHING_PEOPLE_PAGE,
                ),
                drawerSelection: DrawerSelection.search);
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
