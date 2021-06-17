import 'dart:io';

import 'package:firebase_chat_app/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  static final Storage _instance = Storage._internal();

  Storage._internal();

  factory Storage() {
    return _instance;
  }

  Future uploadImageToFirebase(PersonalizedUser user, File imageFile) async {
    firebase_storage.Reference profilePic = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profilePics/${user.uid}');

    firebase_storage.UploadTask uploadTask = profilePic.putFile(imageFile);

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask
        .whenComplete(() => print("Added image to storage"))
        .catchError((e) => print(e));

    await taskSnapshot.ref.getDownloadURL().then(
          (value) => user.profilePicDownloadUrl = value,
        );
  }

  Future<String?> getImageFromFirebase(String id) async {
    try {
      return await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profilePics/$id')
          .getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
