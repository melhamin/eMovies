import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ONE_LEVEL_ELEVATION,
          title: Container(
            child: TextField(
              cursorColor: Theme.of(context).accentColor,
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search movies & TV shows...',
                hintStyle: const TextStyle(color: Colors.white30),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              // onChanged: _updateSearchQuery,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      ),
    );
  }
}
