import 'package:email_validator/email_validator.dart';
import 'package:firebase_chat_app/auth/auth_scaffold.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;

  // Input Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _register() async {
    // Check if the data input is correct and the user is already existent.
    // If exists then output error dialog
    if (_formKey.currentState!.validate()) {
      // Output loading circle
      AuthTools.showLoaderDialog(context);

      // Print the data inputed
      print(_emailController.value.text);
      print(_passwordController.value.text);

      // Create account
      var res = await context.read<AuthenticationService>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      // Remove loading circle when done
      Navigator.pop(context);

      // Check if creation of account was successful
      if (res != ChatApp.SIGN_UP_SUCCESSFUL) {
        ScaffoldMessenger.of(context).showSnackBar(
            AuthTools.errorSnackBar(ChatApp.SIGN_UP_FAILED_MESSAGE));
      }
    } else {
      // Clear both inputs and show popup saying user doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(text: 'Register', body: _registerBody());
  }

  Widget _registerBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create an account',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required!';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please input a valid email';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Email",
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                  color: Colors.purple,
                  fontStyle: FontStyle.italic,
                ),
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required!';
                } else if (value != _confirmPasswordController.value.text) {
                  return "Passwords don't match!";
                }
                return null;
              },
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.lock,
                  ),
                  onPressed: _toggle,
                ),
                labelText: 'Password',
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                  color: Colors.purple,
                  fontStyle: FontStyle.italic,
                ),
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required!';
                } else if (value != _passwordController.value.text) {
                  return "Passwords don't match!";
                }
                return null;
              },
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.lock,
                  ),
                  onPressed: _toggle,
                ),
                labelText: 'Confirm Password',
                hintText: 'Enter your password again',
                hintStyle: TextStyle(
                  color: Colors.purple,
                  fontStyle: FontStyle.italic,
                ),
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text(
                "Register",
                style: TextStyle(fontSize: 18.0),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
            ),
          ],
        ),
      ),
    );
  }
}
