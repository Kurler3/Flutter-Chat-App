import 'package:firebase_chat_app/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(text: "Login", body: loginBody());
  }

  Widget loginBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    // Check if the data input is correct and the user exists.
                    // If exists then procced to home page and send the users data as an argument
                  },
                  icon: Icon(FontAwesomeIcons.arrowRight),
                  label: Text(
                    "Log In",
                    style: TextStyle(fontSize: 18.0),
                  )),
            ],
          ),
        ),
        TextButton(
            onPressed: () {},
            child: Text("Don't have an account? Click here to register!"))
      ]),
    );
  }
}

class AuthInputField extends StatelessWidget {
  final String text;

  AuthInputField(this.text);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
