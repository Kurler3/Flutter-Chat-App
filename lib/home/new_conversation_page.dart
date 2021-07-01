import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/search_page.dart';
import 'package:firebase_chat_app/home/searching_page_widget.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';

class NewConversationPage extends StatefulWidget {
  static const String route = '/newConversation';

  final PersonalizedUser currentUser;

  const NewConversationPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _NewConversationPageState createState() =>
      _NewConversationPageState(this.currentUser);
}

class _NewConversationPageState extends State<NewConversationPage> {
  final PersonalizedUser _currentUser;

  _NewConversationPageState(this._currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose People'),
        centerTitle: true,
      ),
      body: SearchBody(
          currentUser: _currentUser, typePage: ChatApp.NEW_CONVERSATION_PAGE),
    );
  }
}
