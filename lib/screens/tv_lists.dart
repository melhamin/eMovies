import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/screens/add_item_dialog.dart';
import 'package:e_movies/screens/list_item_screen.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TVshowsLists extends StatefulWidget {
  @override
  _TVshowsListsState createState() => _TVshowsListsState();
}

class _TVshowsListsState extends State<TVshowsLists> with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController;

  GlobalKey<AnimatedListState> _listKey;
  bool _isEditing = false;
  bool _initLoaded = true;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _listKey = GlobalKey<AnimatedListState>(debugLabel: 'TVListsKey');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    // _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      // animated lists
      _loadLists();
    }
      _initLoaded = false;
    super.didChangeDependencies();
  }

  /// Builds route with animation to selected list item.
  /// [list] Selected list item
  Route _buildRoute(String title, MediaType mediaType,
      [bool isFavorites = false]) {    
    return MaterialPageRoute(
      builder: (context) => ListItemScreen(title: title, mediaType: mediaType, isFavorites: isFavorites),
      
    );   
  }

  /// Inserts, already loaded lists from shared preferences, to AnimatedList
  void _loadLists() {
    // Lists are already fetched from shared preferences when app is opened
    // Get loaded lists
    final _myLists = Provider.of<Lists>(context, listen: false).tvLists;

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
    Provider.of<Lists>(context, listen: false).removeTVList(title);
    ToastUtils.myToastMessage(
      context: context,
      alignment: Alignment.center,
      color: ONE_LEVEL_ELEVATION,
      duration: Duration(seconds: TOAST_DURATION),
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

  /// Presents a modalBottomSheet and lets user to give a name and add new list
  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          AddItemDialog(listKey: _listKey, mediaType: MediaType.TV),
    );
  }

  /// Builds the first item of the list(Add new list)
  Widget _buildCustomTiles(
      BuildContext context, String title, Widget child, Function onTap) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: DEFAULT_PADDING),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              color: ONE_LEVEL_ELEVATION,
              child: child,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  title,
                  style: kListsItemTitleStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds dismissible list item
  /// [list] is the list item that its details will be build
  /// [index] is index of the current element. It is used for removing item from AnimatedList(if not deleted manualy a range exception would be thrown)
  Widget _buildListItem(ListItemModel list, int index) {
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
        _deleteList(list.title);
      },
      confirmDismiss: (_) => _confirmDeletion(),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: _isEditing ? 8 : 1,
            child: MyListsItem(
                list: list,
                onTap: () {
                  Navigator.of(context)
                      .push(_buildRoute(list.title, MediaType.TV));
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
                  _deleteList(list.title);
                },
              ),
            )
        ],
      ),
    );
  }

  // insert the new listed created from outside this widget to animated list
  void insertItemAddedFromOutside() {
    _listKey.currentState.insertItem(0);
    Provider.of<Lists>(context).toggleTVListsUpdated();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tvLists = Provider.of<Lists>(context).tvLists;
    final tvListsUpdated = Provider.of<Lists>(context).tvListsUpdated;

    if(tvListsUpdated) insertItemAddedFromOutside();

    return ListView(
      key: PageStorageKey('TvLists'),
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      physics:  const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        _buildCustomTiles(context, 'Create List',
            Icon(Icons.add, size: 40, color: Colors.white.withOpacity(0.60)),
            () {
          _showAddDialog(context);
        }),
        SizedBox(height: 5),
        _buildCustomTiles(
            context,
            'Favorites',
            Icon(Icons.favorite_border,
                size: 40, color: Theme.of(context).accentColor), () {
          Navigator.of(context)
              .push(_buildRoute('Favorites', MediaType.TV, true));
        }),
        SizedBox(height: 10),
        AnimatedList(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          key: _listKey,
          itemBuilder: (ctx, i, animation) {
            // print('tvLists[i] ---------> $i');
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive(Tween<Offset>(
                // animate form right end to left end
                begin: Offset(1, 0),
                end: Offset(0, 0),
              )),
              child: _buildListItem(tvLists[i], i),
            );
          },
        ),
      ],
    );
  }

  @override  
  bool get wantKeepAlive => true;
}
