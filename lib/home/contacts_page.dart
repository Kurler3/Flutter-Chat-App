import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  static const String route = '/contacts';
  final user;

  ContactsPage(this.user);

  @override
  _ContactsPageState createState() => _ContactsPageState(user);
}

class _ContactsPageState extends State<ContactsPage> {
  final user;

  _ContactsPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        user, 'Contacts', _contactsHome(), DrawerSelection.contacts);
  }

  Widget _contactsHome() {
    return Container();
  }
}
