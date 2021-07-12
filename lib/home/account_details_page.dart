import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';

class AccountDetailsPage extends StatefulWidget {
  final PersonalizedUser currentUser;

  const AccountDetailsPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late PersonalizedUser _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "First Name",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(_currentUser.firstName,
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Last Name", style: TextStyle(fontSize: 15)),
                      Text(_currentUser.lastName,
                          style: TextStyle(fontSize: 15))
                    ],
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
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                )),
          )
        ],
      ),
    );
  }
}
