import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ChatApp.SIGN_IN_SUCCESSFUL;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return ChatApp.SIGN_UP_SUCCESSFUL;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();

      return ChatApp.SIGN_OUT_SUCCESSFUL;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
