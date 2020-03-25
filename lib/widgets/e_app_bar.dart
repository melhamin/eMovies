import 'package:e_movies/genres.dart';
import 'package:flutter/material.dart';

class EAppBar extends StatefulWidget {
  @override
  _EAppBarState createState() => _EAppBarState();
}

class _EAppBarState extends State<EAppBar> {
  TextEditingController _searchFieldController;
  bool _isSearching;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchFieldController = TextEditingController();
    _isSearching = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchFieldController.dispose();
  }

  

  List<Widget> _buildActions() {
    if (_isSearching)
      return [
        IconButton(
          color: Colors.white70,
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchFieldController == null ||
                _searchFieldController.text.isEmpty) {
              setState(() {
                _isSearching = false;
              });
              return;
            }
            _searchFieldController.clear();
          },
        ),
      ];
    return [
      IconButton(
        color: Colors.white70,
        icon: Icon(Icons.search),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });                          
        },
      ),
    ];
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchFieldController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search movies...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: _isSearching ? _buildSearchField() : EMoviesIcon(),
      leading: _isSearching ? BackButton() : null,
      actions: _buildActions(),
    );
  }
}

class EMoviesIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text('eMovies'),
    );
  }
}
