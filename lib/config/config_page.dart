import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/auth/login_page.dart';
import 'package:firebase_chat_app/auth/register_page.dart';
import 'package:firebase_chat_app/home/home_page.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_app/config/index.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    getToken();
  }

  void setUp() {
    _configBloc = ConfigBloc();

    _configBloc.darkMode =
        ChatApp.prefs.getBool(ChatApp.DARK_MODE_PREF) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          // Initially the user isn't logged in
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
          theme: ThemeData(
            //* Custom Google Font
            fontFamily: ChatApp.google_sans_family,
            primarySwatch: Colors.blue,
            primaryColor: _configBloc.darkMode ? Colors.black : Colors.blue,
            disabledColor: Colors.grey,
            cardColor: _configBloc.darkMode ? Colors.black : Colors.blue,
            canvasColor: _configBloc.darkMode ? Colors.black : Colors.grey[50],
            brightness:
                _configBloc.darkMode ? Brightness.dark : Brightness.light,
            buttonTheme: Theme.of(context).buttonTheme.copyWith(
                colorScheme: _configBloc.darkMode
                    ? ColorScheme.dark()
                    : ColorScheme.light()),
            appBarTheme: AppBarTheme(
              elevation: 0.0,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: AuthenticationWrapper(),
          routes: {
            LoginPage.route: (context) => LoginPage(),
            RegisterPage.route: (context) => RegisterPage(),
          }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the user is not null then go straight to home page
    User? firebaseUser = context.watch<User?>();

    return firebaseUser == null ? LoginPage() : HomePage(firebaseUser);
  }
}
