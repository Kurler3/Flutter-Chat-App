import 'package:flutter/material.dart';

class AuthTools {
  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 2),
    );
  }

  static SnackBar successSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
        message,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 2),
    );
  }
}
