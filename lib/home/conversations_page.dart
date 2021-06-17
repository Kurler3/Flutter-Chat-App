import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  static const String route = '/conversations';
  final user;

  ConversationsPage(this.user);

  @override
  _ConversationsPageState createState() => _ConversationsPageState(user);
}

class _ConversationsPageState extends State<ConversationsPage> {
  final user;

  _ConversationsPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(user, 'Conversations', _conversationsHome(),
        DrawerSelection.conversations);
  }

  Widget _conversationsHome() {
    return Container();
  }
}
