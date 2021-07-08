import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';

class Conversation {
  var uid;
  var lastMessage;
  List<PersonalizedUser> users = [];

  Conversation(
      {required this.uid, required this.lastMessage, required this.users});

  static Conversation fromFirestore(DocumentSnapshot doc) {
    return Conversation(
      uid: getConversationID(doc['users'][0]['id'], doc['users'][1]['id']),
      lastMessage: doc['lastMessage'],
      users: doc['users']
          .map<PersonalizedUser>(
              (userInJson) => PersonalizedUser.fromJson(userInJson))
          .toList(),
    );
  }
}
