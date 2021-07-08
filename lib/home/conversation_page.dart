import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationPage extends StatefulWidget {
  static const String route = '/conversation';

  final PersonalizedUser userFrom;
  final PersonalizedUser userTo;

  const ConversationPage(
      {Key? key, required this.userFrom, required this.userTo})
      : super(key: key);

  @override
  _ConversationPageState createState() =>
      _ConversationPageState(userFrom, userTo);
}

class _ConversationPageState extends State<ConversationPage> {
  final PersonalizedUser _userFrom;
  final PersonalizedUser _userTo;

  _ConversationPageState(this._userFrom, this._userTo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ChatScreen(userFrom: _userFrom, userTo: _userTo),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            // radius: 50.0,
            backgroundColor: _userTo.profilePicDownloadUrl == null
                ? _userTo.avatarBackgroundColor
                : null,
            child: _userTo.profilePicDownloadUrl == null
                ? Center(
                    child: Text(
                      _userTo.firstName[0],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: _userTo.profilePicDownloadUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                    placeholder: (context, url) => new SpinKitFadingCircle(
                          color: Colors.white,
                          size: 40.0,
                        ),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.error)),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            children: [
              Text(
                '${_userTo.firstName} ${_userTo.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Have to figure this out later
              Text(
                'Active now',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      // Implement the settings here
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final PersonalizedUser userFrom;
  final PersonalizedUser userTo;

  const ChatScreen({Key? key, required this.userFrom, required this.userTo})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PersonalizedUser _userFrom;
  late PersonalizedUser _userTo;
  late String _convoID;

  TextEditingController _messageController = new TextEditingController();
  ScrollController _listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _userFrom = widget.userFrom;
    _userTo = widget.userTo;
    _convoID = getConversationID(_userFrom.uid, _userTo.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMessages(),
        buildInput(),
      ],
    );
  }

  Widget buildMessages() {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
      stream: DatabaseTools().getConversationStream(_convoID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.docs.forEach((element) {
            print('${element['content']}');
          });

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) =>
                buildItem(index, snapshot.data!.docs[index]),
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            controller: _listScrollController,
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 50.0,
            ),
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

        // No messages so its just going to be empty for now
        return Center(
          child: Text("No Messages"),
        );
      },
    ));
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    PersonalizedUser documentUserFrom =
        PersonalizedUser.fromJson(document['userFrom']);
    PersonalizedUser documentUserTo =
        PersonalizedUser.fromJson(document['userTo']);

    if (!document['read'] && documentUserTo.uid == _userFrom.uid) {
      DatabaseTools().updateMessageRead(document, _convoID);
    }

    // If the message was sent by the user opening the screen or if the user is messaging himself
    if (documentUserFrom.uid == _userFrom.uid || _userFrom.uid == _userTo.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Bubble(
                color: Colors.blue[200],
                elevation: 0,
                padding: const BubbleEdges.all(10.0),
                nip: BubbleNip.rightBottom,
                child: Text(document['content'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 5),
            child: getUserCircleAvatar(_userFrom, 19),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                child: Bubble(
                    color: Colors.grey[200],
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: BubbleNip.leftBottom,
                    child: Text(
                      document['content'],
                      style: TextStyle(color: Colors.black),
                    )),
                width: 200.0,
                margin: const EdgeInsets.only(left: 10.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 5),
                child: getUserCircleAvatar(_userTo, 19),
              )
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  Widget buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: SafeArea(
          child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                color: Colors.blue[800],
              )),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.64),
                      )),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: 5,
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Type message", border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          IconButton(
              onPressed: () => onSendMessage(_messageController.text),
              icon: Icon(
                Icons.send,
                size: 25,
                color: Colors.blue[800],
              ))
        ],
      )),
    );
  }

  // Adds document to conversation
  void onSendMessage(String content) {
    if (content.trim() != '') {
      _messageController.clear();
      content = content.trim();
      DatabaseTools().sendMessage(_convoID, _userFrom, _userTo, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      _listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
