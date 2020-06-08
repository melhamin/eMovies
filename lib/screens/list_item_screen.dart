import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/my_stateful_builder.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/my_app_bar.dart';
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

    var listTitle = '';    

    if (!widget.isFavorites && items.isNotEmpty)
      listTitle = Provider.of<Lists>(context, listen: false).lists[widget.index]
          ['title'];

    // print('image url ------------> ${items[0]['posterUrl']}');

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if(items.isEmpty)
            Center(child: Text('No Items!', style: kTitleStyle)),
            if(items.isNotEmpty)
            MyAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              floating: false,
              snap: false,
              pinned: false,
              flexibleSpace: Stack(
                children: [
                  // Creates a zoom in effect on the background image
                  MyStatefulBuilder(                    
                    items: items,
                  ),
                  Positioned.fill(
                    bottom: -2, // 
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            BASELINE_COLOR.withOpacity(1),
                            BASELINE_COLOR.withOpacity(0.006),
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
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.isFavorites ? 'Favorites' : listTitle,
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
                    },
                  ),
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
