import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/list_data_item.dart';
import 'package:e_movies/providers/lists.dart';

class ListItemScreen extends StatefulWidget {
  final int index;
  final bool isFavorites;
  ListItemScreen({this.index, this.isFavorites = false});
  @override
  _ListItemScreenState createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen> {
  void _deleteItem(String title, int id) {
    Provider.of<Lists>(context, listen: false).deleteItemFromList(title, id);
  }

  void _deleteFavoriteItem(int id) {
    Provider.of<Lists>(context, listen: false).removeFavorites(id);
  }

  Future<bool> _confirmDeletion() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ONE_LEVEL_ELEVATION,
        title: Text('Confirm', style: kTitleStyle),
        content: Text(
          'Are you sure to delete the list?',
          style: kBodyStyle,
        ),
        actions: <Widget>[
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop(false);
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

  @override
  Widget build(BuildContext context) {
    final dynamic items = widget.isFavorites
        ? Provider.of<Lists>(context).favorites
        : Provider.of<Lists>(context).lists[widget.index]['data'];

    final listTitle = Provider.of<Lists>(context, listen: false).lists[widget.index]['title'];
        
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(            
            widget.isFavorites ? 'Favorites' : listTitle,
            style: kTitleStyle,
          ),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.only(top: 15),
            physics: const BouncingScrollPhysics(
                parent: const AlwaysScrollableScrollPhysics()),
            itemCount: items.length,
            itemBuilder: (context, i) {
              // print('item [i] --------> ${items[0]}');
              var data = items[i];              
              // print('data ----------> $data');
              // return Container();
              return Dismissible(
                background: Container(
                  color: Theme.of(context).errorColor,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 60),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => widget.isFavorites
                    ? _deleteFavoriteItem(items[i]['id'])
                    : _deleteItem(listTitle, items[i]['id']),
                confirmDismiss: (_) => _confirmDeletion(),
                key: UniqueKey(),
                child: ListDataItem(data),
              );
            }),
      ),
    );
  }
}
