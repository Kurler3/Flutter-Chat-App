import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_chat_app/auth/auth_scaffold.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/data_storage/storage.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_chat_app/user.dart';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Istance to create random ids
  // final _uuid = Uuid();

  // Initially password is obscure
  bool _obscureText = true;

  // Image picked by user
  File? _image;

  // Image picker
  final picker = ImagePicker();

  Future _getImage() async {
    // print('Open gallery');
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }

    print(_image);
  }

  // Input Controllers
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
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

      // Create account
      var user = await context.read<AuthenticationService>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      // Remove loading circle when done
      Navigator.pop(context);

      // Check if creation of account was successful
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            AuthTools.errorSnackBar(ChatApp.SIGN_UP_FAILED_MESSAGE));
      } else {
        // Save data to firebase database
        // If no image was uploaded then upload a custom anonymous one
        // Go back to the login page

        PersonalizedUser newUser = new PersonalizedUser(
            // v4 generates random Id, v1 generates time-based id
            // uid: _uuid.v4(),
            uid: user.uid,
            profilePic: _image == null ? null : _image!.path,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            phoneNumber: _phoneNumberController.text);

        // Save in the database
        DatabaseTools().saveUser(newUser);

        // Save profile pic to storage. If there's no pic then use the first letter of the first name instead
        if (_image != null) Storage().uploadImageToFirebase(newUser, _image!);

        // Show dialog
        ScaffoldMessenger.of(context).showSnackBar(
            AuthTools.successSnackBar(ChatApp.SIGN_UP_SUCCESS_MESSAGE));

        // Wait for 1 second
        Future.delayed(Duration(seconds: 1));

        // Enter home page
        Navigator.pop(context);
      }
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
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Create an account',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            _avatarPickerWidget(),
            SizedBox(
              height: 20,
            ),
            _textFieldWidget(
                _firstNameController,
                ChatApp.REGISTER_FIRST_NAME_LABEL,
                ChatApp.REGISTER_FIRST_NAME_HINT,
                false,
                false),
            SizedBox(
              height: 15,
            ),
            _textFieldWidget(
                _lastNameController,
                ChatApp.REGISTER_LAST_NAME_LABEL,
                ChatApp.REGISTER_LAST_NAME_HINT,
                false,
                false),
            SizedBox(
              height: 15,
            ),
            _textFieldWidget(_emailController, ChatApp.REGISTER_EMAIL_LABEL,
                ChatApp.REGISTER_EMAIL_HINT, true, false),
            SizedBox(
              height: 15,
            ),
            _textFieldWidget(
                _phoneNumberController,
                ChatApp.REGISTER_PHONE_NUMBER_LABEL,
                ChatApp.REGISTER_PHONE_NUMBER_HINT,
                false,
                false),
            SizedBox(
              height: 15,
            ),
            _textFieldWidget(
                _passwordController,
                ChatApp.REGISTER_PASSWORD_LABEL,
                ChatApp.REGISTER_PASSWORD_HINT,
                false,
                true),
            SizedBox(
              height: 15,
            ),
            _textFieldWidget(
                _confirmPasswordController,
                ChatApp.REGISTER_CONFIRM_PASSWORD_LABEL,
                ChatApp.REGISTER_CONFIRM_PASSWORD_HINT,
                false,
                true),
            SizedBox(
              height: 15,
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

  Widget _textFieldWidget(TextEditingController controller, String labelText,
      String hintText, bool isEmailField, bool isPasswordField) {
    return Container(
      height: 55,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required!';
          }
          if (isEmailField) {
            if (!EmailValidator.validate(value)) {
              return 'Please input a valid email';
            }
          }
          if (isPasswordField) {
            if (value.length < 6) {
              return 'Password needs to be at least 6 characters long!';
            }
            if (controller == _passwordController) {
              if (value != _confirmPasswordController.text)
                return "Passwords don't match!";
            } else {
              if (value != _passwordController.text)
                return "Passwords don't match";
            }
          }
          return null;
        },
        obscureText: isPasswordField ? _obscureText : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? FontAwesomeIcons.lock
                        : FontAwesomeIcons.unlock,
                  ),
                  onPressed: _toggle,
                )
              : null,
          labelText: labelText,
          hintText: hintText,
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
    );
  }

  Widget _avatarPickerWidget() {
    return InkWell(
        onTap: _getImage,
        child: IgnorePointer(
            child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50.0,
          child: CircleAvatar(
            radius: 48.0,
            child: CircleAvatar(
              radius: 48.0 - 3,
              backgroundImage: (_image != null)
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ).image
                  : null,
              // child: ClipOval(
              //   child: (_image != null)
              //       ? Image.file(
              //           _image!,
              //           fit: BoxFit.cover,
              //         )
              //       : Center(
              //           child: Icon(Icons.insert_photo),
              //         ),
              // ),
              backgroundColor: Colors.white,
            ),
          ),
        )));
  }
}
