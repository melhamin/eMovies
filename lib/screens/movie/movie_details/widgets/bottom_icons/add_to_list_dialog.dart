import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/bottom_icons/toast_message_details.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_new_list_dialog.dart';

class AddToListDialog extends StatelessWidget {
  final InitData initData;
  const AddToListDialog({
    Key key,
    this.initData,
  }) : super(key: key);

  void _showAddNewListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddNewListDialog(initData: initData),
    );
  }

  void _addNewItemtoList(BuildContext context, int index, InitData item) {
    final result = Provider.of<Lists>(context, listen: false)
        .addNewMovieToList(index, item);
    if (result) {
      Navigator.of(context).pop();
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: ToastMessageDetails(
            icon: Icon(Icons.done,
                color: Colors.white.withOpacity(0.87), size: 50),
            message: 'Item added.',
          ));
    } else {
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: ToastMessageDetails(
          icon: Icon(Icons.warning,
              color: Colors.white.withOpacity(0.87), size: 50),
          message: 'Item is already in the list.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<Lists>(context, listen: false).moviesLists;
    final mq = MediaQuery.of(context);    
    return Container(
      padding: const EdgeInsets.only(),
      decoration: BoxDecoration(
        // color: Colors.black,
        color: BASELINE_COLOR,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView(
        children: <Widget>[
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: ONE_LEVEL_ELEVATION,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.cen,
              children: <Widget>[
                CupertinoButton(
                  // width: 82,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Helvatica',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Text('Add to List', style: kTitleStyle),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
          Container(
            height: mq.size.height * 0.75,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              itemCount:
                  lists.length + 1, // since first element is New List button
              itemBuilder: (context, i) {
                return i == 0
                    ? Center(
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => _showAddNewListDialog(context),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            width: mq.size.width / 2,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).accentColor,
                            ),
                            child: Center(
                                child: Text('New List', style: kTitleStyle)),
                          ),
                        ),
                      )
                    : Material(
                        color: Colors.transparent,
                        child: MyListsItem(
                          list: lists[i - 1],
                          onTap: () =>
                              _addNewItemtoList(context, i - 1, initData),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
