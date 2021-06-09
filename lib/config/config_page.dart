import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_app/config/index.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  var _configBloc;

  @override
  void initState() {
    super.initState();

    setUp();
  }

  void setUp() {
    _configBloc = ConfigBloc();

    _configBloc.darkMode =
        ChatApp.prefs.getBool(ChatApp.DARK_MODE_PREF) ?? false;
  }

  Widget configScreen() {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Config'),
      //   centerTitle: true,
      // ),
      body: ConfigScreen(_configBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //* Custom Google Font
        fontFamily: ChatApp.google_sans_family,
        primarySwatch: Colors.blue,
        primaryColor: _configBloc.darkMode ? Colors.black : Colors.blue,
        disabledColor: Colors.grey,
        cardColor: _configBloc.darkMode ? Colors.black : Colors.blue,
        canvasColor: _configBloc.darkMode ? Colors.black : Colors.grey[50],
        brightness: _configBloc.darkMode ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: _configBloc.darkMode
                ? ColorScheme.dark()
                : ColorScheme.light()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
      ),
      home: ConfigScreen(_configBloc),
      // routes: {

      // }
    );
  }
}
