import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/data_storage/storage.dart';
import 'package:firebase_chat_app/home/drawer_selection.dart';
import 'package:firebase_chat_app/home/home_scaffold.dart';
import 'package:firebase_chat_app/home/search_bar.dart';
import 'package:firebase_chat_app/home/search_interface.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const String route = '/search';

  final user;

  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState(this.user);
}

class _SearchPageState extends State<SearchPage> implements Searchable {
  final currentLoggedUser;
  String? _term;

  late Future<List<PersonalizedUser>> _userList;

  _SearchPageState(this.currentLoggedUser);

  @override
  void initState() {
    super.initState();
    _userList = DatabaseTools().getUsers(_term);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        currentLoggedUser, 'Search', _usersList(), DrawerSelection.search);
  }

  // Widget _usersList() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: DatabaseTools().getUserStream(),
  //       builder: (ctx, snapshot) {
  //         if (snapshot.connectionState != ConnectionState.done) {
  //           return Center(
  //             child: SpinKitFadingCircle(
  //               color: Colors.blue,
  //               size: 50.0,
  //             ),
  //           );
  //         }

  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasData) {

  //             List<QueryDocumentSnapshot> users = snapshot.data!.docs;

  //             // List<PersonalizedUser> usersList =
  //             //   await Future.wait(usersFromSnapshot(usersSnapshot));

  //           } else if (snapshot.hasError) {
  //             return Center(
  //               child: Text(
  //                 '${snapshot.error} occured',
  //                 style: TextStyle(fontSize: 18),
  //               ),
  //             );
  //           }
  //         }

  //         return Center(
  //           child: Text(
  //             'No Users Found :(',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //         );
  //       });
  // }

  Widget _usersList() {
    return FutureBuilder<List<PersonalizedUser>>(
        future: _userList,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          }

          // snapshot.hasData and snapshot.hasError aren't reset until new data comes
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<PersonalizedUser> users = snapshot.data!;

              // Will print everytime the list changes, or so I hope lmao
              users.forEach((element) {
                print('${element.firstName} ${element.lastName}');
              });

              return SearchBar(
                  this,
                  'Search for people...',
                  ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 1),
                    padding: const EdgeInsets.only(top: 60),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, index) {
                      return SizedBox(
                          height: 60,
                          child: SearchUserListTile(
                            key: Key(users[index].uid),
                            currentLoggedUser: currentLoggedUser,
                            userFromList: users[index],
                          ));
                    },
                  ));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
          }

          // If there's no users in the database, which will never happen actually
          return Center(
            child: Text(
              'No Users Found :(',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        });
  }

  // Will make the widget rebuild everytime the term is updated
  @override
  void search(String? term) {
    print('interface is working');

    // Should make the whole screen rebuild but it isn't working
    setState(() {
      _userList = DatabaseTools().getUsers(term);
    });
  }
}

class SearchUserListTile extends StatefulWidget {
  final currentLoggedUser;
  final userFromList;

  const SearchUserListTile(
      {Key? key, this.currentLoggedUser, this.userFromList})
      : super(key: key);

  // SearchUserListTile(this.key, this.currentLoggedUser, this.userFromList);

  @override
  _SearchUserListTileState createState() =>
      _SearchUserListTileState(currentLoggedUser, userFromList);
}

class _SearchUserListTileState extends State<SearchUserListTile> {
  final PersonalizedUser _currentLoggedUser;
  final _userFromList;

  late bool _addedAsFriend;

  _SearchUserListTileState(this._currentLoggedUser, this._userFromList);

  @override
  Widget build(BuildContext context) {
    // Will be false if this user isn't friends with the current user
    _addedAsFriend = _currentLoggedUser.friends.contains(_userFromList);

    return ListTile(
      key: widget.key,
      leading: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: _userFromList.profilePicDownloadUrl == null
              ? _userFromList.avatarBackgroundColor
              : null,
          child: _userFromList.profilePicDownloadUrl == null
              ? Center(
                  child: Text(
                    _userFromList.firstName[0],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: _userFromList.profilePicDownloadUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  placeholder: (context, url) => new SpinKitFadingCircle(
                        color: Colors.white,
                        size: 40.0,
                      ),
                  errorWidget: (context, url, error) => new Icon(Icons.error)),
        ),
      ),
      title: new Text(
        '${_userFromList.firstName} ${_userFromList.lastName}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // Check if this user is the same as the logged in one.
      trailing: _userFromList.uid != _currentLoggedUser.uid
          ? ActionChip(
              label: Text(_addedAsFriend ? 'Remove Friend' : 'Add Friend'),
              onPressed: () {
                // Depending on if this user is added or not as friend
                if (_addedAsFriend) {
                  // Remove from the users friend list
                  _currentLoggedUser.friends.remove(_userFromList);
                } else {
                  // Add to the users friend list
                  _currentLoggedUser.friends.add(_userFromList);
                }

                // Update in the database

                // Update the _addedAsFriend variable
                setState(() {
                  _addedAsFriend = !_addedAsFriend;
                });
              },
            )
          : null,
    );
  }
}
