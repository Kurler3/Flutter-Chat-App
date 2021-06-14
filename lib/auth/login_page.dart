import 'package:email_validator/email_validator.dart';
import 'package:firebase_chat_app/auth/auth_scaffold.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/auth/register_page.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _tryingToLogIn = true;

  // Initially password is obscure
  bool _obscureText = true;

  // Input Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationService authentication =
        context.read<AuthenticationService>();

    return AuthScaffold(text: "Login", body: loginBody(authentication));
  }

  Widget loginBody(AuthenticationService authentication) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60.0),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required!';
                    } else if (!EmailValidator.validate(value)) {
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
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? FontAwesomeIcons.lock
                            : FontAwesomeIcons.unlock,
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
                ElevatedButton.icon(
                  onPressed: () async {
                    // Check if the data input is correct and the user exists.
                    // If exists then procced to home page and send the users data as an argument
                    if (_formKey.currentState!.validate()) {
                      // launch loading circle as a dialog
                      AuthTools.showLoaderDialog(context);

                      // Print the data inputed
                      print(_emailController.value.text);
                      print(_passwordController.value.text);

                      // Check on Firebase
                      var res = await authentication.signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim());

                      // Remove dialog
                      Navigator.pop(context);

                      // If there was an error show dialog saying there was an error, otherwise just goes in new home
                      if (res != ChatApp.SIGN_IN_SUCCESSFUL) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            AuthTools.errorSnackBar(
                                ChatApp.LOGIN_FAILED_MESSAGE));
                      }
                    }
                  },
                  icon: Icon(FontAwesomeIcons.arrowRight),
                  label: Text(
                    "Log In",
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
        ),
        TextButton(
            onPressed: () {
              // Navigate to register page
              Navigator.pushNamed(context, RegisterPage.route);
            },
            child: Text("Don't have an account? Click here to register!"))
      ]),
    );
  }
}

// class AuthInputField extends StatelessWidget {
//   final String text;

//   AuthInputField(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: text,
//         hintText: 'Enter your $text',
//         hintStyle: TextStyle(
//           color: Colors.purple,
//           fontStyle: FontStyle.italic,
//         ),
//         errorText: 'Oops, something went wrong!',
//         errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blueAccent,
//           ),
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.grey,
//           ),
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.red,
//           ),
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//       ),
//     );
//   }
// }
