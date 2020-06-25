import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/screens/add_item_dialog.dart';
import 'package:e_movies/screens/list_item_screen.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLists extends StatefulWidget {
  final InitData initData;
  final bool isOut;
  @required
  final MediaType mediaType;
  MyLists({this.mediaType, this.initData, this.isOut = false});

  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  TextEditingController _textEditingController;

  GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _listKey = GlobalKey<AnimatedListState>();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// Builds route with animation to selected list item.
  /// [list] Selected list item
  Route _buildRoute(String title, MediaType mediaType,
      [bool isFavorites = false]) {
    return MaterialPageRoute(
      builder: (context) => ListItemScreen(
          title: title, mediaType: widget.mediaType, isFavorites: isFavorites),
    );
  }

  Widget _buildToastMessageIcons(Icon icon, String message,
      [double iconSize = 50]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 10),
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
    widget.mediaType == MediaType.Movie
        ? Provider.of<Lists>(context, listen: false).removeMovieList(title)
        : Provider.of<Lists>(context, listen: false).removeTVList(title);
    ToastUtils.myToastMessage(
      context: context,
      alignment: Alignment.center,
      color: ONE_LEVEL_ELEVATION,
      duration: Duration(seconds: TOAST_DURATION),
      child: _buildToastMessageIcons(
          Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 70),
          'Removed\n$title'),
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
          AddItemDialog(listKey: _listKey, mediaType: widget.mediaType),
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
        padding: const EdgeInsets.only(left: LEFT_PADDING),
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
      child: MyListsItem(
          list: list,
          onTap: () {
            // pass list's data to buildRoute
            Navigator.of(context)
                .push(_buildRoute(list.title, widget.mediaType));
          }),
    );
  }

  // if MoviesLists is built in tv or movie details screen, this function will add the item to the
  // list instead of navigating to the list screen
  void _fromOutsideAddHandler(InitData item, int index) {
    final result = widget.mediaType == MediaType.Movie
        ? Provider.of<Lists>(context, listen: false)
            .addNewMovieToList(index, item)
        : Provider.of<Lists>(context, listen: false)
            .addNewTVToList(index, item);
    if (result) {
      Navigator.of(context).pop();
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 50),
              'Item added.'));
    } else {
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.warning,
                  color: Colors.white.withOpacity(0.87), size: 50),
              'Item is already in the list.'));
    }
  }

  Widget outList(ListItemModel list, int index) {
    return Container(
      // color: Colors.red,
      child: Row(
        children: <Widget>[
          Flexible(            
            child: MyListsItem(
              list: list,
              onTap: () => _fromOutsideAddHandler(widget.initData, index),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return widget.isOut
        ? Center(
            child: Container(
              // margin: const EdgeInsets.only(bottom: 20.0),
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).accentColor,
              ),
              child: FlatButton(
                child: Text('New List', style: kTitleStyle),
                onPressed: () => _showAddDialog(context),
              ),
            ),
          )
        : _buildCustomTiles(context, 'Create List',
            Icon(Icons.add, size: 40, color: Colors.white.withOpacity(0.60)),
            () {
            _showAddDialog(context);
          });
  }

  Widget _buildFavoriteList() {
    return _buildCustomTiles(
        context,
        'Favorites',
        Icon(Icons.favorite_border,
            size: 40, color: Theme.of(context).accentColor), () {
      Navigator.of(context)
          .push(_buildRoute('Favorites', widget.mediaType, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('moviesLists'),
      padding:
          EdgeInsets.only(bottom: kToolbarHeight, top: widget.isOut ? 10 : 0),
      children: <Widget>[
        _buildAddButton(),
        if (!widget.isOut) _buildFavoriteList(),
        SizedBox(height: 10),
        Consumer<Lists>(builder: (ctx, item, _) {
          final moviesLists = widget.mediaType == MediaType.Movie ? item.moviesLists : item.tvLists;
          return AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: moviesLists.length,
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
                child: widget.isOut
                    ? outList(moviesLists[i], i)
                    : _buildListItem(moviesLists[i], i),
              );
            },
          );
        }),
      ],
    );
  }
}
