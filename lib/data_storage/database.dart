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
      user = new PersonalizedUser(
          uid: element.get('id'),
          firstName: element.get('first_name'),
          lastName: element.get('last_name'),
          email: element.get('email'),
          password: element.get('password'),
          phoneNumber: element.get('phone_number'));
    });

    // Acess Storage for the users profile pic and add it to the instance if it exists, otherwise make it null
    user.profilePicDownloadUrl = await Storage().getImageFromFirebase(user.uid);

    // If the user didn't choose an image then select a random color for his avatar background
    if (user.profilePicDownloadUrl == null) {
      user.avatarBackgroundColor = ChatApp.AVATAR_BACKGROUND_COLORS[
          Random().nextInt(ChatApp.AVATAR_BACKGROUND_COLORS.length)];
    }

    return user;
  }
}
