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

  Future<PersonalizedUser?> getUser(String id) async {
    try {
      QuerySnapshot userSnapshot = await users.where('id', isEqualTo: id).get();
      late PersonalizedUser user;
      if (userSnapshot.size > 1) {
        userSnapshot.docs.forEach((element) {
          user = new PersonalizedUser(
              uid: element.get('id'),
              firstName: element.get('id'),
              lastName: element.get('id'),
              email: element.get('id'),
              password: element.get('id'),
              phoneNumber: element.get('id'));
        });

        // Acess Storage for the users profile pic and add it to the instance if it exists, otherwise make it null
        user.profilePicDownloadUrl =
            await Storage().getImageFromFirebase(user.uid);

        return user;
      } else
        return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
