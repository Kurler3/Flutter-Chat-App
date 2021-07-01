import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController textEditingController;

  const SearchBar({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState(textEditingController);
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _textEditingController;

  _SearchBarState(this._textEditingController);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintMaxLines: 1,
          hintText: 'Search for someone...',
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
