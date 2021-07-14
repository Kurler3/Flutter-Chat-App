import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'dart:async';

class DatabaseTools {
  static final DatabaseTools _instance = DatabaseTools._internal();
  DatabaseTools._internal();

  late CollectionReference users;
  late CollectionReference messages;

  factory DatabaseTools() {
    _instance.users = FirebaseFirestore.instance.collection('users');
    _instance.messages = FirebaseFirestore.instance.collection('messages');
    return _instance;
  }

  // Users Collection Methods

  Future<void> saveUser(PersonalizedUser user) async {
    print(users);
    return await users
        .doc(user.uid)
        .set(user.toJson())
        .then((value) => print(ChatApp.REGISTER_SUCCESSFUL_ADDED_USER_DATABASE))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future updateUser(PersonalizedUser user) async {
    return await users
        .doc(user.uid)
        .update({"profile_pic_url": user.profilePicDownloadUrl});
  }

  Future updateUserFirstLastName(
      PersonalizedUser user, String firstName, String lastName) async {
    return await users
        .doc(user.uid)
        .update({"first_name": firstName, "last_name": lastName});
  }

  Future<PersonalizedUser> getUser(String id) async {
    QuerySnapshot userSnapshot = await users.where('id', isEqualTo: id).get();
    late PersonalizedUser user;

    userSnapshot.docs.forEach((element) {
      Map<String, dynamic> userJson = element.data() as Map<String, dynamic>;
      user = PersonalizedUser.fromJson(userJson);
    });

    return user;
  }

  Stream<DocumentSnapshot> getUserStream(String id) {
    return users.doc(id).snapshots();
  }

  Future<List<PersonalizedUser>> getUsers() async {
    QuerySnapshot usersSnapshot = await users.get();
    return await Future.wait(usersFromSnapshot(usersSnapshot));
  }

  Iterable<Future<PersonalizedUser>> usersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((element) async {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      return PersonalizedUser.fromJson(data);
    });
  }

  Future<List<PersonalizedUser>> getFriendUsers(
      PersonalizedUser currentUser) async {
    return currentUser.friends;
  }

  Future<String> updateUsersFriendList(PersonalizedUser user) async {
    try {
      users.where('id', isEqualTo: user.uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference
              .update({'friends': jsonEncode(user.friends)});
        });
      });

      return ChatApp.UPDATE_FRIENDS_LIST_SUCCESSFUL;
    } catch (e) {
      return e.toString();
    }
  }

  // Messages Collection Methods

  Stream<QuerySnapshot> getConversationStream(String convoID) async* {
    // If the convoDoc doesn't exist then this is the first message between these two users
    // So first need to save the conv with the convoID as it's document ID
    await messages.doc(convoID).get().then((documentSnapshot) async {
      if (!documentSnapshot.exists) {
        // Create a document (need to specify its document ID)
        await messages
            .doc(convoID)
            .set({
              'lastMessage': <String, dynamic>{
                'userFrom': {},
                'userTo': {},
                'timestamp': '',
                'content': '',
                'read': false
              },
              'users': []
            })
            .then((value) => print(ChatApp.CREATE_CONVO_SUCCESSFUL))
            .catchError((error) => print("Failed to create convo: $error"));
      }
    });

    yield* messages
        .doc(convoID)
        .collection(convoID)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }

  void updateMessageRead(DocumentSnapshot doc, convoID) async {
    // Conversation reference
    final DocumentReference convoDocReference = messages.doc(convoID);

    // Conversation snapshot
    final DocumentSnapshot convoReference = await messages.doc(convoID).get();

    // Message reference
    final DocumentReference documentReference =
        messages.doc(convoID).collection(convoID).doc(doc.id);

    documentReference
        .set(<String, dynamic>{'read': true}, SetOptions(merge: true));

    // If this message was the last one
    if (doc.id == convoReference['lastMessage']['timestamp']) {
      convoDocReference.set({
        'lastMessage': {'read': true}
      }, SetOptions(merge: true));
    }
  }

  void sendMessage(
    String convoID,
    PersonalizedUser userFrom,
    PersonalizedUser userTo,
    String content,
    String timestamp,
  ) async {
    final DocumentReference convoDoc = messages.doc(convoID);

    convoDoc.update(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'userFrom': userFrom.toJson(),
        'userTo': userTo.toJson(),
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': [userFrom.toJson(), userTo.toJson()]
    }).then((dynamic success) {
      // If the conversation was updated successfully then
      // Add this new message to the documents of this conversation collection

      final DocumentReference messageDoc =
          messages.doc(convoID).collection(convoID).doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        transaction.set(
          messageDoc,
          <String, dynamic>{
            'userFrom': userFrom.toJson(),
            'userTo': userTo.toJson(),
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  Stream<QuerySnapshot> getConversationsStream(
      PersonalizedUser userFrom) async* {
    yield* messages
        .where('users', arrayContains: userFrom.toJson())
        .orderBy('lastMessage.timestamp', descending: true)
        .snapshots();
  }
}
