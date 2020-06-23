import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/my_stateful_builder.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/list_data_item.dart';
import 'package:e_movies/providers/lists.dart';

class ListItemScreen extends StatefulWidget {
  final String title;
  final MediaType mediaType;
  final bool isFavorites;
  ListItemScreen({this.title, this.mediaType, this.isFavorites = false});
  @override
  _ListItemScreenState createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _deleteItem(String title, int id) {
    Provider.of<Lists>(context, listen: false).removeMovieFromList(title, id);
  }

  void _deleteFavoriteItem(int id) {
    Provider.of<Lists>(context, listen: false).removeFavoriteMovie(id);
  }

  void _onDismissed(MediaType mediaType, int id) {
    if (mediaType == MediaType.Movie) {
      if (widget.isFavorites)
        Provider.of<Lists>(context, listen: false).removeFavoriteMovie(id);
      else
        Provider.of<Lists>(context, listen: false)
            .removeMovieFromList(widget.title, id);
    } else {
      if (widget.isFavorites)
        Provider.of<Lists>(context, listen: false).removeFavoriteTV(id);
      else
        Provider.of<Lists>(context, listen: false)
            .removeTVFromList(widget.title, id);
    }
  }

  Future<bool> _confirmDeletion(String message) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ONE_LEVEL_ELEVATION,
        title: Text('Confirm', style: kTitleStyle),
        content: Text(
          message,
          style: kBodyStyle,
        ),
        actions: <Widget>[
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop(false);
              return false;
            },
            child: Text(
              "No",
              style: kTitleStyle,
            ),
            color: Theme.of(context).accentColor,
          ),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop(true);
              return true;
            },
            child: Text(
              "Yes",
              style: kTitleStyle,
            ),
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }

  List<InitData> getListItems() {
    var items;
    if (widget.mediaType == MediaType.Movie) {
      if (widget.isFavorites)
        items = Provider.of<Lists>(context).favoriteMovies;
      else
        items = Provider.of<Lists>(context).getMovieList(widget.title).items;
    } else {
      if (widget.isFavorites)
        items = Provider.of<Lists>(context).favoriteTVs;
      else
        items = Provider.of<Lists>(context).getTVList(widget.title).items;
    }

    return items;
  }

  void _removeAllItems() {
    Future<bool> confirmed =
        _confirmDeletion('This action can\'t be undone. Are you sure?');
    confirmed.then((value) {
      if (value) {
        if (widget.mediaType == MediaType.Movie) {
          Provider.of<Lists>(context, listen: false)
              .removeAllListItemsMovie(widget.title);
        } else {
          Provider.of<Lists>(context, listen: false)
              .removeAllListItemsTV(widget.title);
        }
      }
    });
  }

  void _deleteList() {
    Future<bool> confirmed =
        _confirmDeletion('This action can\'t be undone. Are you sure?');
    confirmed.then((value) {
      if (value) {
        if (widget.mediaType == MediaType.Movie) {
          Navigator.of(context).pop();
          Provider.of<Lists>(context, listen: false)
              .removeMovieList(widget.title);
        } else {
          Provider.of<Lists>(context, listen: false)
              .removeAllListItemsTV(widget.title);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {    
    final items = getListItems();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if (items.isEmpty)
              Center(child: Text('No Items!', style: kTitleStyle)),
            if (items.isNotEmpty)
              MyAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                floating: false,
                snap: false,
                pinned: false,
                flexibleSpace: Stack(
                  children: [
                    // Creates a zoom in effect on the background image
                    MyStatefulBuilder(items: items),
                    Positioned.fill(
                      bottom: -2,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              BASELINE_COLOR.withOpacity(1),
                              BASELINE_COLOR.withOpacity(0.01),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                body: ListView(
                  padding: const EdgeInsets.only(top: 15),                  
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: TextStyle(
                                fontFamily: 'Helvatica',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.87),
                              )),
                          SizedBox(height: 10),
                          Text('${items.length} items', style: kSubtitle1),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        var data = items[i];
                        return Dismissible(
                          background: Container(
                            color: Theme.of(context).errorColor,
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width - 60),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) =>
                              _onDismissed(items[i].mediaType, items[i].id),
                          confirmDismiss: (_) =>
                              _confirmDeletion('Are you sure to delete item?'),
                          key: UniqueKey(),
                          // convert Map<String,dynamic> to InitialData for adding to the lists
                          child: ListDataItem(data),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          disabledBorderColor: Theme.of(context).errorColor,
                          highlightedBorderColor: Theme.of(context).errorColor,
                          focusColor: Theme.of(context).errorColor,
                          hoverColor: Theme.of(context).errorColor,
                          highlightColor: Theme.of(context).errorColor,
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                          color: Theme.of(context).errorColor,
                          child: Text('Remove all', style: kTitleStyle2),
                          onPressed: () => _removeAllItems(),
                        ),
                      ),
                    ),
                    // SizedBox(height: 15),
                    // if (!widget.isFavorites)
                    //   Align(
                    //     alignment: Alignment.center,
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width * 0.4,
                    //       child: OutlineButton(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(50),
                    //         ),
                    //         disabledBorderColor: Theme.of(context).errorColor,
                    //         highlightedBorderColor:
                    //             Theme.of(context).errorColor,
                    //         focusColor: Theme.of(context).errorColor,
                    //         hoverColor: Theme.of(context).errorColor,
                    //         highlightColor: Theme.of(context).errorColor,
                    //         borderSide:
                    //             BorderSide(color: Colors.red, width: 1.5),
                    //         color: Theme.of(context).errorColor,
                    //         child: Text('Delete list', style: kTitleStyle2),
                    //         onPressed: () => _deleteList(),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            Positioned(
              top: 10,
              left: 10,
              child: CustomBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
