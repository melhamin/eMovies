import 'package:e_movies/pages/list_item_screen.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyListsScreen extends StatefulWidget {
  @override
  _MyListsScreenState createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TextEditingController _textEditingController;
  GlobalKey<FormState> _formKey;
  bool _isEditing = false;

  bool _isEmpty = true;

  void initState() {
    print('lists screen init ---------------------> calleld');
    super.initState();
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Lists>(context, listen: false).loadLists();
    // });
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
    print('tex---------> ${_textEditingController.text}');
    Provider.of<Lists>(context, listen: false)
        .addNewList(_textEditingController.text);
    setState(() {
      _isEmpty = true;
    });
    _textEditingController.clear();
    Navigator.of(context).pop();
  }

  void _deleteList(String title) {
    Provider.of<Lists>(context, listen: false).deleteList(title);
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, thisState) {
          return Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              color: BASELINE_COLOR,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.85,
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          _textEditingController.clear();
                          Navigator.of(context).pop();
                          setState(() {
                            _isEmpty = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Give your list a name.',
                    style: TextStyle(
                      color: Hexcolor('#DEDEDE'),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvatica',
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white38),
                        ),
                      ),
                      child: TextFormField(
                        controller: _textEditingController,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        onChanged: (val) {
                          thisState(() {
                            _isEmpty = val.isEmpty ? true : false;
                          });
                        },
                        // autovalidate: true,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                          color: Hexcolor('#DEDEDE'),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvatica',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvatica',
                          ),
                        ),
                        textInputAction: TextInputAction.go,
                        keyboardAppearance: Brightness.dark,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter a name.';
                          return null;
                        },
                        onFieldSubmitted: (value) => _addList(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                    child: _isEmpty
                        ? FlatButton(
                            child: Text(
                              'Cancel',
                              style: kTitleStyle2,
                            ),
                            onPressed: () {
                              _textEditingController.clear();
                              Navigator.of(context).pop();
                              setState(() {
                                _isEmpty = true;
                              });
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text('Create', style: kTitleStyle),
                                  onPressed: () => _addList(context),
                                ),
                              ),
                            ),
                          ))
              ],
            ),
          );
        },
      ),
    );
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

  Widget _buildAddItemTile(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          _isEditing = false;
        });
        _showAddDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.only(left: LEFT_PADDING),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              color: ONE_LEVEL_ELEVATION,
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white54,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Create list',
                  style: TextStyle(
                    fontFamily: 'Helvatica',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Hexcolor('#DEDEDE'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Provider.of<Lists>(context, listen: false).loadLists();
  }

  Route _buildRoute(Map<String, dynamic> list) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          (ListItemScreen(list)),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final moviesLists = Provider.of<Lists>(context).moviesLists;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ONE_LEVEL_ELEVATION,
          leading: Center(
            child: Container(
              width: 150,
              child: IconButton(
                icon: Text(
                  (_isEditing) ? 'Done' : 'Edit',
                  style: TextStyle(
                    fontFamily: 'Helvatica',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: (moviesLists.length == 0 && !_isEditing)
                    ? null
                    : () {
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
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.white,
          backgroundColor: Theme.of(context).accentColor,
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: kToolbarHeight, top: 20),
              physics: const BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics()),
              itemCount: moviesLists.length +
                  1, // first element will be add new list tile
              itemBuilder: (context, i) {
                return i == 0
                    ? _buildAddItemTile(context)
                    : Dismissible(
                        direction: DismissDirection.endToStart,
                        key: UniqueKey(),
                        background: Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width - 60),
                          color: Theme.of(context).errorColor,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          _deleteList(moviesLists[i - 1]['title']);
                        },
                        confirmDismiss: (_) => _confirmDeletion(),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: _isEditing ? 8 : 1,
                              child: MyListsItem(
                                  list: moviesLists[i - 1],
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(_buildRoute(moviesLists[i - 1]));
                                  }),
                            ),
                            if (_isEditing)
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.minus_circled),
                                  color: Colors.red,
                                  onPressed: () {
                                    _confirmDeletion().then((value) {
                                      if (value)
                                        _deleteList(
                                            moviesLists[i - 1]['title']);
                                      return;
                                    });
                                  },
                                ),
                              )
                          ],
                        ),
                      );
              }),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
