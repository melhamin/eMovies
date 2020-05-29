import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/list_data_item.dart';
import 'package:e_movies/providers/lists.dart';

class ListItemScreen extends StatefulWidget {
  final Map<String, dynamic> list;
  ListItemScreen(this.list);
  @override
  _ListItemScreenState createState() => _ListItemScreenState();
}

class _ListItemScreenState extends State<ListItemScreen> {
  void _deleteItem(String title, int id) {
    Provider.of<Lists>(context, listen: false).deleteItemFromList(title, id);
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
    // print(widget.list);
    print('list ============> ${widget.list}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.list['title'],
            style: kTitleStyle,
          ),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: widget.list['data'].length,
            itemBuilder: (context, i) {
              var data = widget.list['data'][i];
              print('data ----------> $data');
              // return Container();
              return Dismissible(
                background: Container(
                  color: Theme.of(context).errorColor,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 60),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteItem(
                    widget.list['title'], widget.list['data'][i]['id']),
                confirmDismiss: (_) => _confirmDeletion(),
                key: UniqueKey(),
                child: ListDataItem(data),
              );
            }),
      ),
    );
  }
}
