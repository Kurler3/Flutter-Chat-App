import 'package:cached_network_image/cached_network_image.dart';
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
    return HomeScaffold(
        currentLoggedUser,
        'Search',
        SearchBody(
          currentUser: currentLoggedUser,
          typePage: ChatApp.SEARCHING_PEOPLE_PAGE,
        ),
        DrawerSelection.search);
  }
}
