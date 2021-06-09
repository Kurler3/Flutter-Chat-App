import 'package:firebase_chat_app/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(text: "Login", body: loginBody());
  }

  Widget loginBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40.0),
          AuthInputField('Email'),
          SizedBox(
            height: 20,
          ),
          AuthInputField('Password'),
        ],
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  final String text;

  AuthInputField(this.text);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: text,
        hintText: 'Enter your $text',
        hintStyle: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
        ),
        errorText: 'Oops, something went wrong!',
        errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
