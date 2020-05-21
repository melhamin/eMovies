import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/lists.dart';

class MyListsScreen extends StatefulWidget {
  @override
  _MyListsScreenState createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen> with AutomaticKeepAliveClientMixin{
  TextEditingController _textEditingController;
  GlobalKey<FormState> _formKey;
  bool _isEditing = false;

  void initState() {
    print('lists screen init ---------------------> calleld');
    super.initState();
    _textEditingController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _addList(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    Provider.of<Lists>(context, listen: false)
        .addNewListToMovies(_textEditingController.text);
    Navigator.of(context).pop();
    _textEditingController.text = '';
  }

  void _deleteList(String title) {
    Provider.of<Lists>(context, listen: false).deleteList(title);
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BASELINE_COLOR,
        title: Text(
          'New List',
          style: kTitleStyle,
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _textEditingController,
            cursorColor: Theme.of(context).accentColor,
            style: kBodyStyle,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: kSubtitle1,
              // focusedBorder: InputBorder()
            ),
            keyboardAppearance: Brightness.dark,
            validator: (value) {
              if (value.isEmpty) return 'Please enter a title.';
              return null;
            },
            onFieldSubmitted: (value) => _addList(context),
          ),
        ),
        elevation: 10,
        actions: <Widget>[
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: kTitleStyle,
            ),
            color: Theme.of(context).accentColor,
          ),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => _addList(context),
            child: Text(
              "Add",
              style: kTitleStyle,
            ),
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDeletion() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BASELINE_COLOR,
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
    final moviesLists = Provider.of<Lists>(context).moviesLists;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Container(
              width: 100,
              child: IconButton(
                icon: Text(
                  _isEditing ? 'Done' : 'Edit',
                  style: kTBStyle,
                ),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'My Lists',
            style: kTitleStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 25,
              color: !_isEditing ? Theme.of(context).accentColor : Colors.grey,
              onPressed: () => !_isEditing ? _showAddDialog(context) : null,
            )
          ],
        ),
        body: ListView.separated(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(left: 65, right: LEFT_PADDING),
                child: Divider(
                  color: kTextBorderColor,
                  thickness: 0.5,
                ),
              );
            },
            itemCount: moviesLists.length,
            itemBuilder: (context, i) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                background: Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 60),
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  _deleteList(moviesLists[i]['title']);
                },
                confirmDismiss: (direction) => _confirmDeletion(),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: LEFT_PADDING, vertical: 0),
                  dense: true,                  
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor:
                        i == 0 ? Colors.green : Theme.of(context).accentColor,
                    child: Icon(
                      i == 0 ? Icons.done : i == 1 ? Icons.add : Icons.star,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(moviesLists[i]['title'], style: kListTitleStyle),
                  trailing:

                      //TODO fix not animating issue
                      AnimatedContainer(
                    // color: Colors.red,
                    duration: Duration(seconds: 3),
                    width: _isEditing ? 60 : 20,
                    // height: _isEditing ? 60 : 20,
                    child: Row(
                      children: <Widget>[
                        Text('${moviesLists[i]['data'].length}',
                            style: kSubtitle1),
                        if (_isEditing)
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                _confirmDeletion().then((value) => {
                                      if (value)
                                        _deleteList(moviesLists[i]['title']),
                                    });
                              }),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
