import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/conversation.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/home/conversation_page.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/search_bar.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversationsPage extends StatefulWidget {
  static const String route = '/conversations';
  final user;

  ConversationsPage(this.user);

  @override
  _ConversationsPageState createState() => _ConversationsPageState(user);
}

class _ConversationsPageState extends State<ConversationsPage> {
  final PersonalizedUser user;

  _ConversationsPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(user, 'Conversations', _conversationsHome(),
        DrawerSelection.conversations);
  }

  Widget _conversationsHome() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseTools().getConversationsStream(user),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          );
        }

        if (snapshot.hasData) {
          final List<Conversation> conversations = snapshot.data!.docs
              .map((DocumentSnapshot doc) => Conversation.fromFirestore(doc))
              // .where((convo) => convo.users[0].uid == user.uid)
              .toList();

          return ConversationsBody(
            currentUser: user,
            conversationsList: conversations,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error} occured',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Center(
          child: Text(
            "You haven't talked to anyone yet :(",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ConversationsBody extends StatefulWidget {
  PersonalizedUser currentUser;
  List<Conversation> conversationsList;

  ConversationsBody(
      {Key? key, required this.currentUser, required this.conversationsList})
      : super(key: key);

  @override
  _ConversationsBodyState createState() => _ConversationsBodyState();
}

class _ConversationsBodyState extends State<ConversationsBody> {
  late final List<Conversation> _conversationsList;
  late final PersonalizedUser _currentUser;

  List<Conversation> filteredConversationsList = [];

  TextEditingController _searchController = TextEditingController();
  String? _term;

  @override
  void initState() {
    super.initState();
    _conversationsList = widget.conversationsList;
    _currentUser = widget.currentUser;

    _searchController.addListener(_searchListener);
    searchConversationsList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SearchBar(textEditingController: _searchController),
        SizedBox(
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _conversationsList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConversationPage(
                                userFrom: _conversationsList[index].users[0],
                                userTo: _conversationsList[index].users[1])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getUserCircleAvatar(
                          isCurrentUserDisplay(
                                  _currentUser, _conversationsList[index])
                              ? _conversationsList[index].users[1]
                              : _conversationsList[index].users[0],
                          22),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          '${isCurrentUserDisplay(_currentUser, _conversationsList[index]) ? _conversationsList[index].users[1].firstName : _conversationsList[index].users[0].firstName}')
                    ],
                  ),
                );
              }),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 5,
                thickness: 2,
              ),
              itemCount: filteredConversationsList.length,
              itemBuilder: (ctx, index) {
                return SizedBox(
                    height: 60,
                    child: ConversationListTile(
                      key: Key(filteredConversationsList[index].uid),
                      currentUser: _currentUser,
                      conversation: filteredConversationsList[index],
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }

  _searchListener() {
    setState(() {
      _term = _searchController.text;
      // Update the UI
      searchConversationsList();
    });
  }

  searchConversationsList() {
    setState(() {
      if (_term != null) {
        filteredConversationsList = _conversationsList
            .where((conversation) =>
                conversation.users[1].firstName
                    .toLowerCase()
                    .contains(_term!.toLowerCase()) ||
                conversation.users[1].lastName
                    .toLowerCase()
                    .contains(_term!.toLowerCase()))
            .toList();
      } else {
        filteredConversationsList = _conversationsList;
      }
    });
  }
}

class ConversationListTile extends StatefulWidget {
  final PersonalizedUser currentUser;
  final Conversation conversation;

  const ConversationListTile(
      {Key? key, required this.currentUser, required this.conversation})
      : super(key: key);

  @override
  _ConversationListTileState createState() => _ConversationListTileState();
}

class _ConversationListTileState extends State<ConversationListTile> {
  late Conversation _conversation;
  late final PersonalizedUser _currentUser;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _currentUser = widget.currentUser;
  }

  @override
  void didUpdateWidget(covariant ConversationListTile oldWidget) {
    if (_conversation.lastMessage['timestamp'] !=
        widget.conversation.lastMessage['timestamp']) {
      setState(() {
        _conversation = widget.conversation;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getUserCircleAvatar(
          isCurrentUserDisplay(_currentUser, _conversation)
              ? _conversation.users[1]
              : _conversation.users[0],
          20),
      title: Text(
        isCurrentUserDisplay(_currentUser, _conversation)
            ? '${_conversation.users[1].firstName} ${_conversation.users[1].lastName}'
            : '${_conversation.users[0].firstName} ${_conversation.users[0].lastName}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${_conversation.lastMessage['userFrom']['id'] == _currentUser.uid ? 'You : ' : ''}${_conversation.lastMessage['content']} - ${readTimestamp(_conversation.lastMessage['timestamp'])}',
        style: _conversation.lastMessage['read'] == false &&
                _conversation.lastMessage['userTo']['id'] == _currentUser.uid
            ? TextStyle(color: Colors.black)
            : null,
      ),
      trailing: _conversation.lastMessage['read'] == false &&
              _conversation.lastMessage['userTo']['id'] == _currentUser.uid
          ? Icon(
              FontAwesomeIcons.solidCircle,
              color: Colors.black,
              size: 10,
            )
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationPage(
                    userFrom: _currentUser,
                    userTo: _currentUser.uid == _conversation.users[0].uid
                        ? _conversation.users[1]
                        : _conversation.users[0])));
      },
    );
  }
}
