import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/data_storage/database.dart';
import 'package:firebase_chat_app/home/conversation_page.dart';
import 'package:firebase_chat_app/home/search_bar.dart';
import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_chat_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchBody extends StatefulWidget {
  final PersonalizedUser currentUser;
  final String typePage;

  const SearchBody(
      {Key? key, required this.currentUser, required this.typePage})
      : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState(currentUser, typePage);
}

class _SearchBodyState extends State<SearchBody> {
  final PersonalizedUser _currentUser;
  final String _typePage;

  _SearchBodyState(this._currentUser, this._typePage);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonalizedUser>>(
        future: _typePage == ChatApp.SEARCHING_PEOPLE_PAGE
            ? DatabaseTools().getUsers()
            : DatabaseTools().getFriendUsers(_currentUser),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          }

          if (snapshot.hasData) {
            return UserList(
                key: UniqueKey(),
                currentUser: _currentUser,
                usersList: snapshot.data!,
                typePage: _typePage);
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Center(
            child: Text(
              'No Users Found :(',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}

class UserList extends StatefulWidget {
  final PersonalizedUser currentUser;
  final List<PersonalizedUser> usersList;
  final String typePage;

  const UserList(
      {Key? key,
      required this.currentUser,
      required this.usersList,
      required this.typePage})
      : super(key: key);

  @override
  _UserListState createState() => _UserListState(
      currentUser: currentUser, usersList: usersList, typePage: typePage);
}

class _UserListState extends State<UserList> {
  final PersonalizedUser currentUser;
  final List<PersonalizedUser> usersList;
  final String typePage;
  List<PersonalizedUser> _usersList = [];

  TextEditingController _searchController = TextEditingController();
  String? _term;

  _UserListState(
      {required this.currentUser,
      required this.usersList,
      required this.typePage});

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchListener);

    searchUsersList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  _searchListener() {
    setState(() {
      _term = _searchController.text;
      // Update the UI
      searchUsersList();
    });
  }

  searchUsersList() {
    setState(() {
      if (_term != null) {
        _usersList = usersList
            .where((user) =>
                user.firstName.toLowerCase().contains(_term!.toLowerCase()) ||
                user.lastName.toLowerCase().contains(_term!.toLowerCase()))
            .toList();
      } else {
        _usersList = usersList;
      }
    });

    _usersList.forEach((element) {
      print(element.firstName + ' ' + element.lastName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SearchBar(textEditingController: _searchController),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 5,
              thickness: 2,
            ),
            padding: const EdgeInsets.only(top: 60),
            itemCount: _usersList.length,
            itemBuilder: (ctx, index) {
              return SizedBox(
                  height: 60,
                  child: UserListTile(
                      key: Key(_usersList[index].uid),
                      currentLoggedUser: currentUser,
                      userFromList: _usersList[index],
                      typePage: typePage));
            },
          ),
        ),
      ],
    );
  }
}

class UserListTile extends StatefulWidget {
  final currentLoggedUser;
  final userFromList;
  final String typePage;

  const UserListTile(
      {Key? key,
      required this.currentLoggedUser,
      required this.userFromList,
      required this.typePage})
      : super(key: key);

  @override
  _UserListTileState createState() =>
      _UserListTileState(currentLoggedUser, userFromList, typePage);
}

class _UserListTileState extends State<UserListTile> {
  final PersonalizedUser _currentLoggedUser;
  final _userFromList;
  final String _typePage;

  late bool _addedAsFriend;

  _UserListTileState(
      this._currentLoggedUser, this._userFromList, this._typePage);

  @override
  Widget build(BuildContext context) {
    // Will be false if this user isn't friends with the current user
    _addedAsFriend = _currentLoggedUser.friends.contains(_userFromList);

    return ListTile(
      key: widget.key,
      onTap: () {
        // Opens the conversation page with this user
        // If this is clicked while on the new conversation page, then use pushReplacement
        // else use push

        if (_typePage == ChatApp.NEW_CONVERSATION_PAGE) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationPage(
                      userFrom: _currentLoggedUser, userTo: _userFromList)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationPage(
                      userFrom: _currentLoggedUser, userTo: _userFromList)));
        }
      },
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
      trailing: _typePage != ChatApp.NEW_CONVERSATION_PAGE
          ? _userFromList.uid != _currentLoggedUser.uid
              ? ActionChip(
                  label: Text(_addedAsFriend ? 'Unfriend' : 'Add Friend'),
                  onPressed: () async {
                    // Depending on if this user is added or not as friend
                    if (_addedAsFriend) {
                      // Remove from the users friend list
                      _currentLoggedUser.friends.remove(_userFromList);
                    } else {
                      // Add to the users friend list
                      _currentLoggedUser.friends.add(_userFromList);
                    }

                    // Update in the database
                    String updateResult = await DatabaseTools()
                        .updateUsersFriendList(_currentLoggedUser);

                    if (updateResult ==
                        ChatApp.UPDATE_FRIENDS_LIST_SUCCESSFUL) {
                      print("Friend list updated");
                    } else {
                      // Prints the error
                      print(updateResult);
                    }

                    // Update the _addedAsFriend variable
                    setState(() {
                      _addedAsFriend = !_addedAsFriend;
                    });
                  },
                )
              // Edit the second null to the selected icon if the user selects that user (only when dealing with groups in the future)
              : null
          : null,
    );
  }
}
