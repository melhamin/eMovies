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
  var expanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    expanded = false;
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
            // decoration: BoxDecoration(                         
            //   border:
            //       Border(bottom: BorderSide(color: kTextBorderColor, width: 1)),
            // ),            
            child: TextField(
              cursorColor: Theme.of(context).accentColor,
              controller: _searchController,
              autofocus: true,              
              decoration: const InputDecoration(
                // contentPadding: const EdgeInsets.only(left: 10),
                isDense: true,
                // icon: Icon(Icons.search, color: Colors.white38,),                
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
          child: Center(
            child: Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    color: Colors.red,
                    onPressed: () {
                      Provider.of<Lists>(context, listen: false).savePrefs();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    color: Colors.red,
                    onPressed: () {
                      Provider.of<Lists>(context, listen: false).printPrefs();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    color: Colors.red,
                    onPressed: () {
                      Provider.of<Lists>(context, listen: false).deleteAllPrefs();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
