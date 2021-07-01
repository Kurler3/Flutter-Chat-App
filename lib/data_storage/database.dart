import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/data_storage/storage.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';

class DatabaseTools {
  static final DatabaseTools _instance = DatabaseTools._internal();
  DatabaseTools._internal();

  late CollectionReference users;

  factory DatabaseTools() {
    _instance.users = FirebaseFirestore.instance.collection('users');
    return _instance;
  }

  Future<void> saveUser(PersonalizedUser user) async {
    print(users);
    return await users
        .add(user.toJson())
        .then((value) => print(ChatApp.REGISTER_SUCCESSFUL_ADDED_USER_DATABASE))
        .catchError((error) => print("Failed to add user: $error"));
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
}
