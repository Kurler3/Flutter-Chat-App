import 'package:firebase_chat_app/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_chat_app/config/index.dart';

class ConfigScreen extends StatefulWidget {
  final ConfigBloc _configBloc;

  ConfigScreen(this._configBloc);

  @override
  ConfigScreenState createState() {
    return ConfigScreenState();
  }
}

class ConfigScreenState extends State<ConfigScreen>
    with SingleTickerProviderStateMixin {
  ConfigScreenState();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationController.addListener(() {
      setState(() {});
    });

    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _load() {
    widget._configBloc.add(LoadConfigEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
        bloc: widget._configBloc,
        builder: (
          BuildContext context,
          ConfigState currentState,
        ) {
          if (currentState is UnConfigState) {
            _animationController.forward();
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _animationController.value,
                  child: child,
                );
              },
              child: Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image(
                      image:
                          AssetImage('assets/images/splash_screen_light.jpg'),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            );
          }
          if (currentState is ErrorConfigState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InConfigState) {
            // Return the auth widget instead
            return LoginPage();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
