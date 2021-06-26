import 'package:firebase_chat_app/home/search_interface.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBar extends StatefulWidget {
  final Searchable searchable;
  final String title;
  final Widget body;

  SearchBar(this.searchable, this.title, this.body);

  @override
  _SearchBarState createState() => _SearchBarState(searchable, title, body);
}

class _SearchBarState extends State<SearchBar> {
  static const historyLength = 5;

  final Searchable searchable;
  final String title;
  final Widget body;

  _SearchBarState(this.searchable, this.title, this.body);

  // Full list of search history
  // Since will be pushing to the bottom then will have to reserve list later
  List<String> _searchHistory = [];

  // The list that will appear in the UI
  List<String> filteredSearchHistory = [];

  String? selectedTerm;

  List<String> filterSearchTerms(String? filter) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    // Check for duplicates
    if (_searchHistory.contains(term)) {
      // Move the term to the bottom, which will be displayed as most recent in the UI
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);

    // Limit the search history ammount to historyLength
    if (_searchHistory.length > historyLength) {
      // Remove the oldest term searched(first string in the list)
      _searchHistory.removeAt(0);
    }

    // Update the filtered search history list
    filteredSearchHistory = filterSearchTerms(null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((element) => element == term);

    // Update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(null);
  }

  void putSearchTermFirst(String term) {
    // First delete the term
    deleteSearchTerm(term);
    // Add again
    _searchHistory.add(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    return FloatingSearchBar(
      controller: controller,
      backgroundColor: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      title: Text(
        selectedTerm ?? title,
        //style: TextStyle(color: Colors.white)
      ),
      body: body,
      automaticallyImplyDrawerHamburger: false,
      hint: title,
      actions: [FloatingSearchBarAction.searchToClear()],
      onQueryChanged: (query) {
        // Re-filter the search terms based on the new query
        setState(() {
          filteredSearchHistory = filterSearchTerms(query);
        });
      },
      onSubmitted: onSubmit,
      builder: (ctx, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                // When the search history is empty and the user hasn't typed anything
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    // width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                }
                // else if the search history is empty but the user has typed something
                else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      onSubmit(controller.query);
                    },
                  );
                }
                // Display all the search history terms in a column
                else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map((term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                // Make it be the most recent one and submit
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });

                                searchable.search(term);

                                controller.close();
                              },
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void onSubmit(String query) {
    setState(() {
      addSearchTerm(query);
      selectedTerm = query;
    });

    // Search in the searchable
    searchable.search(selectedTerm);

    // Closes the search bar
    controller.close();
  }
}
