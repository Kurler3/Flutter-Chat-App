import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget body;
  final String text;

  AuthScaffold({required this.text, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[250],
          title: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          // elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: body);
  }
}
