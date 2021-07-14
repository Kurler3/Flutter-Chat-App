import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/auth/auth_service.dart';
import 'package:firebase_chat_app/auth/login_page.dart';
import 'package:firebase_chat_app/home/contacts_page.dart';
import 'package:firebase_chat_app/home/conversations_page.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_page.dart';
import 'package:firebase_chat_app/home/new_conversation_page.dart';
import 'package:firebase_chat_app/home/profile_page.dart';
import 'package:firebase_chat_app/home/search_page.dart';
import 'package:firebase_chat_app/tools/auth_tools.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/tools/helper_functions.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScaffold extends StatefulWidget {
  final user, title, home, drawerSelection;

  HomeScaffold(
      {Key? key,
      required this.user,
      required this.title,
      required this.home,
      required this.drawerSelection});

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  late PersonalizedUser user;
  late DrawerSelection drawerSelection;
  late String title;
  late Widget home;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    drawerSelection = widget.drawerSelection;
    title = widget.title;
    home = widget.home;
  }

  @override
  void didUpdateWidget(covariant HomeScaffold oldWidget) {
    if (user.firstName != oldWidget.user.firstName ||
        user.lastName != widget.user.lastName) {
      setState(() {
        user = widget.user;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // If the user is not null then go straight to whatever page this is
    User? firebaseUser = context.watch<User?>();

    return firebaseUser != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      // Pushes to the page to create a new conversation
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewConversationPage(currentUser: user)));
                    },
                    icon: Icon(Icons.add_comment))
              ],
            ),
            drawer: Drawer(
              child: drawerList(user),
            ),
            body: home,
          )
        : LoginPage();
  }

  Widget drawerList(PersonalizedUser personalizedUser) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
              personalizedUser.firstName + " " + personalizedUser.lastName),
          accountEmail: Text(personalizedUser.email),
          currentAccountPicture: getUserCircleAvatar(personalizedUser, 50),
        ),
        ListTile(
          selected: drawerSelection == DrawerSelection.conversations,
          title: Text(
            'Conversations',
            style: TextStyle(fontSize: 14),
          ),
          leading: Icon(Icons.comment),
          onTap: () {
            // Check if already in the page selected
            if (drawerSelection != DrawerSelection.conversations) {
              // Navigate to selected and replace current selected
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConversationsPage(user)));
            } else {
              // Just pop the drawer back
              Navigator.pop(context);
            }
          },
        ),
        Divider(
          color: Colors.blue[200],
        ),
        ListTile(
          selected: drawerSelection == DrawerSelection.contacts,
          title: Text(
            'Contacts',
            style: TextStyle(fontSize: 14),
          ),
          leading: Icon(FontAwesomeIcons.addressBook),
          onTap: () {
            // Check if already in the page selected
            if (drawerSelection != DrawerSelection.contacts) {
              // Navigate to selected
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ContactsPage(user)));
            } else {
              // Just pop the drawer back
              Navigator.pop(context);
            }
          },
        ),
        Divider(
          color: Colors.blue[200],
        ),
        ListTile(
          selected: drawerSelection == DrawerSelection.search,
          title: Text(
            'Search',
            style: TextStyle(fontSize: 14),
          ),
          leading: Icon(FontAwesomeIcons.search),
          onTap: () {
            // Check if already in the page selected
            if (drawerSelection != DrawerSelection.search) {
              // Navigate to selected
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SearchPage(user)));
            } else {
              // Just pop the drawer back
              Navigator.pop(context);
            }
          },
        ),
        Divider(
          color: Colors.blue[200],
        ),
        ListTile(
          selected: drawerSelection == DrawerSelection.profile,
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 14),
          ),
          leading: Icon(FontAwesomeIcons.userCircle),
          onTap: () {
            // Check if already in the page selected
            if (drawerSelection != DrawerSelection.profile) {
              // Navigate to selected
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user)));
            } else {
              // Just pop the drawer back
              Navigator.pop(context);
            }
          },
        ),
        Divider(
          color: Colors.blue[200],
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(fontSize: 14),
          ),
          leading: Icon(FontAwesomeIcons.signOutAlt),
          onTap: signOut,
        ),
      ],
    );
  }

  void signOut() async {
    // Output loading circle
    AuthTools.showLoaderDialog(context);
    // Sign out
    String res = await context.read<AuthenticationService>().signOut();
    // Remove loading circle
    Navigator.pop(context);
    // Output alert saying it wasn't possible if err
    if (res != ChatApp.SIGN_OUT_SUCCESSFUL) {
      ScaffoldMessenger.of(context)
          .showSnackBar(AuthTools.errorSnackBar(ChatApp.LOGOUT_FAILED_MESSAGE));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          AuthTools.successSnackBar(ChatApp.LOGOUT_SUCCESS_MESSAGE));
    }
  }
}
