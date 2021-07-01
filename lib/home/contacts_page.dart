import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/searching_page_widget.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  static const String route = '/contacts';
  final currentUser;

  ContactsPage(this.currentUser);

  @override
  _ContactsPageState createState() => _ContactsPageState(currentUser);
}

class _ContactsPageState extends State<ContactsPage> {
  final currentUser;

  _ContactsPageState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        currentUser,
        'Contacts',
        SearchBody(
          currentUser: currentUser,
          typePage: ChatApp.SEARCHING_FRIENDS_PAGE,
        ),
        DrawerSelection.contacts);
  }
}
