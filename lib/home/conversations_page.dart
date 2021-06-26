import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/search_bar.dart';
import 'package:firebase_chat_app/home/search_interface.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  static const String route = '/conversations';
  final user;

  ConversationsPage(this.user);

  @override
  _ConversationsPageState createState() => _ConversationsPageState(user);
}

class _ConversationsPageState extends State<ConversationsPage>
    implements Searchable {
  final user;

  String? _term;

  _ConversationsPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(user, 'Conversations', _conversationsHome(),
        DrawerSelection.conversations);
  }

  Widget _conversationsHome() {
    //List of stream of conversations is passed as the body
    return SearchBar(this, 'Search for conversations', _convList(_term));
  }

  Widget _convList(String? term) {
    // Where will search for the convs and return a list of them

    return Container();
  }

  @override
  void search(String? term) {
    setState(() {
      _term = term;
    });
  }
}
