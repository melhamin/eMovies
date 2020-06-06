import 'package:e_movies/my_toast_message.dart';
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
    with TickerProviderStateMixin {
  // var _listItems = <Widget>[];
  TextEditingController _textEditingController;
  GlobalKey<FormState> _formKey;
  GlobalKey<AnimatedListState> _listKey;
  bool _isEditing = false;

  bool _isEmpty = true;

  void initState() {
    print('lists screen init ---------------------> calleld');
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Lists>(context, listen: false).loadLists();
    });
    _textEditingController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _listKey = GlobalKey<AnimatedListState>();
    // animated lists
    _loadLists();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  /// Inserts, already loaded lists from shared preferences, to AnimatedList
  void _loadLists() {
    // Lists are already fetched from shared preferences when app is opened
    // Get loaded lists
    final _myLists = Provider.of<Lists>(context, listen: false).lists;

    var future = Future(() {});
    for (var i = 0; i < _myLists.length; i++) {
      future = future.then((value) {
        // Creates a delayed future for animating items
        return Future.delayed(Duration(milliseconds: 100), () {
          // insert item to the list
          _listKey.currentState.insertItem(i);
        });
      });
    }
  }

  /// Validates name of the new list and adds it to lists
  void _addList(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    // print('tex---------> ${_textEditingController.text}');
    final notInLists = Provider.of<Lists>(context, listen: false)
        .checkForExistence(_textEditingController.text);

    if (notInLists) {
      Provider.of<Lists>(context, listen: false)
          .addNewList(_textEditingController.text);
      _listKey.currentState.insertItem(0,
          duration: Duration(milliseconds: 500)); // add item to animated list
      Navigator.of(context).pop();

      _textEditingController.clear();
      setState(() {
        _isEmpty = true;
      });
    } else {
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: ONE_LEVEL_ELEVATION,
          duration: Duration(seconds: 2),
          child: _buildToastMessageIcons(
              Icon(Icons.warning,
                  color: Colors.white.withOpacity(0.87), size: 60),
              'List Already Exist!'));
    }

    //   if (result)
    //     _listKey.currentState.insertItem(0,
    //         duration: Duration(milliseconds: 500)); // add item to animated list
    //   Navigator.of(context).pop(); // pop confirm deletion dialoge
    //   ToastUtils.showMyToastMessage(
    //       context, 'Added', Alignment.center, Duration(seconds: 1));
  }

  Widget _buildToastMessageIcons(Icon icon, String message,
      [double iconSize = 50]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 15),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.87),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  /// Deletes selectd element form lists
  void _deleteList(String title) {
    Provider.of<Lists>(context, listen: false).deleteList(title);
    ToastUtils.myToastMessage(
      context: context,
      alignment: Alignment.center,
      color: ONE_LEVEL_ELEVATION,
      duration: Duration(seconds: 2),
      child: _buildToastMessageIcons(
          Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 70),
          'Removed list'),
    );
  }

  /// Removes item at index from the AnimatedList
  void _removeListItem(int index) {
    _listKey.currentState.removeItem(index, (context, animation) {
      return SlideTransition(
        position: CurvedAnimation(
          curve: Curves.easeOut,
          parent: animation,
        ).drive(Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(0, 1),
        )),
      );
    }, duration: Duration(milliseconds: 300));
  }

  /// Presents a modalBottomSheet and lets user to give a name and add new list
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
                          onFieldSubmitted: (value) => _addList(context)),
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

  /// Asks for confirmation when list item is dismissed
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

  /// Builds the first item of the list(Add new list)
  Widget _buildCustomTiles(
      BuildContext context, String title, IconData icon, Function onTap) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: onTap,
      // onTap: () {
      //   // disable editing when creating a new list
      //   setState(() {
      //     _isEditing = false;
      //   });
      //   _showAddDialog(context);
      // },
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
                icon,
                size: 40,
                color: Colors.white54,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  title,
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

  /// Builds dismissible list item
  /// [item] is the list item that its details will be buil
  /// [index] is index of the current element. It is used for removing item from AnimatedList(if not deleted manualy a range exception would be thrown)
  Widget _buildListItem(dynamic item, int index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width - 60),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        _removeListItem(index); // index of the element to be removed
        _deleteList(item['title']);
      },
      confirmDismiss: (_) => _confirmDeletion(),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: _isEditing ? 8 : 1,
            child: MyListsItem(
                list: item,
                onTap: () {
                  Navigator.of(context).push(_buildRoute(index));
                }),
          ),
          if (_isEditing)
            Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white.withOpacity(0.45)),
                color: Colors.red,
                onPressed: () {
                  _removeListItem(index);
                  _deleteList(item['title']);
                },
              ),
            )
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Provider.of<Lists>(context, listen: false).loadLists();
  }

  /// Builds route with animation to selected list item.
  /// [list] Selected list item
  Route _buildRoute(int index, [bool isFavorites = false]) {
    // print('list --------------> $list');
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          (ListItemScreen(index: index, isFavorites: isFavorites)),
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
    final moviesLists = Provider.of<Lists>(context).lists;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[],
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
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.white,
          backgroundColor: Theme.of(context).accentColor,
          child: ListView(
            padding: const EdgeInsets.only(bottom: kToolbarHeight, top: 15),
            physics: const BouncingScrollPhysics(
                parent: const AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              _buildCustomTiles(context, 'Create List', Icons.add, () {
                _showAddDialog(context);
              }),
              SizedBox(height: 5),
              _buildCustomTiles(context, 'Favorites', Icons.favorite_border,
                  () {
                Navigator.of(context).push(_buildRoute(
                    0,
                    true));
              }),
              SizedBox(height: 5),
              AnimatedList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                itemBuilder: (ctx, i, animation) {
                  return SlideTransition(
                    position: CurvedAnimation(
                      curve: Curves.easeOut,
                      parent: animation,
                    ).drive(Tween<Offset>(
                      // animate form right end to left end
                      begin: Offset(1, 0),
                      end: Offset(0, 0),
                    )),
                    child: _buildListItem(moviesLists[i], i),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
