import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';

class AccountDetailsPage extends StatefulWidget {
  PersonalizedUser currentUser;

  AccountDetailsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late PersonalizedUser _currentUser;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  String _inputtedFirstName = '';
  String _inputtedLastName = '';

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
    _firstNameController.text = _currentUser.firstName;
    _lastNameController.text = _currentUser.lastName;
  }

  @override
  void didUpdateWidget(covariant AccountDetailsPage oldWidget) {
    if (oldWidget.currentUser != widget.currentUser) {
      setState(() {
        _currentUser = widget.currentUser;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Account Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: accountDetailsBody(),
    );
  }

  _showInputDialog(bool isFirstName) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 80,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(isFirstName ? 'First Name' : 'Last Name'),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: isFirstName
                          ? _firstNameController
                          : _lastNameController,
                      onChanged: (value) {
                        setState(() {
                          isFirstName
                              // ignore: unnecessary_statements
                              ? value != _currentUser.firstName
                                  ? _inputtedFirstName = value
                                  : _inputtedFirstName = ''
                              : _currentUser.lastName != value
                                  ? _inputtedLastName = value
                                  : _inputtedLastName = '';
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget accountDetailsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Text(
              'PUBLIC INFO',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  InkWell(
                    // Can change first name
                    onTap: () => _showInputDialog(true),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                            _inputtedFirstName.isEmpty
                                ? _currentUser.firstName
                                : _inputtedFirstName,
                            style: TextStyle(
                                fontSize: 15,
                                color: _inputtedFirstName.isNotEmpty
                                    ? Colors.red
                                    : null))
                      ],
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () => _showInputDialog(false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Last Name", style: TextStyle(fontSize: 15)),
                        Text(
                            _inputtedLastName.isEmpty
                                ? _currentUser.lastName
                                : _inputtedLastName,
                            style: TextStyle(
                                fontSize: 15,
                                color: _inputtedLastName.isNotEmpty
                                    ? Colors.red
                                    : null))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Text(
              'PRIVATE DETAILS',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email Adress",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(_currentUser.email, style: TextStyle(fontSize: 15))
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phone Number", style: TextStyle(fontSize: 15)),
                      Text(_currentUser.phoneNumber,
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    primary: Colors.white),
                onPressed: _saveNewInformation,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                )),
          )
        ],
      ),
    );
  }

  _saveNewInformation() async {
    // If either of them isn't empty (the user wants to change them) then update the database
    if (_inputtedFirstName.isNotEmpty || _inputtedLastName.isNotEmpty) {
      // Show Alert Dialog
      AuthTools.showLoaderDialog(context);

      await DatabaseTools().updateUserFirstLastName(
          _currentUser,
          _inputtedFirstName.isEmpty
              ? _currentUser.firstName
              : _inputtedFirstName,
          _inputtedLastName.isEmpty
              ? _currentUser.lastName
              : _inputtedLastName);

      // Pop alert dialog when it's done
      Navigator.pop(context);

      // Update the Profile Page's currentUser

    }
  }
}
