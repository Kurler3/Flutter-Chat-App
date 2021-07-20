import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/user.dart';

class Message {
  final String content;
  final String timestamp;
  final bool isRead;
  final PersonalizedUser userFrom;
  final PersonalizedUser userTo;

  Message(
      {required this.content,
      required this.timestamp,
      required this.isRead,
      required this.userFrom,
      required this.userTo});

  static Message fromFirestore(DocumentSnapshot doc) {
    return Message(
        content: doc['content'],
        timestamp: doc['timestamp'],
        isRead: doc['read'],
        userFrom: PersonalizedUser.fromJson(doc['userFrom']),
        userTo: PersonalizedUser.fromJson(doc['userTo']));
  }
}
