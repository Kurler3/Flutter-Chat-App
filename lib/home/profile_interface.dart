import 'package:firebase_chat_app/user.dart';

abstract class OnProfileDetailsChange {
  void updatedCurrentUser(PersonalizedUser updatedCurrentUser);
}
