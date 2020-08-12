import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/bottom_icons/toast_message_details.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../../my_toast_message.dart';
import 'dialog_button.dart';


class AddNewListDialog extends StatelessWidget {
  final InitData initData; // item to be added to top movie genres
  AddNewListDialog({
    Key key,
    @required this.initData,
  }) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  void _addList(BuildContext context) {
    if (textEditingController.text.isEmpty) return;
    // print('tex---------> ${_textEditingController.text}');
    final result = Provider.of<Lists>(context, listen: false).addNewMovieList(
        textEditingController.text, true); // toggle updated lists too
    // Set _isEmpty to true and clear the textfield

    if (result) {
      // update top movie genres list
      Provider.of<Search>(context, listen: false).addToTopMovieGenres(initData);
      Navigator.of(context).pop();
      textEditingController.clear();
    } else {
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: ToastMessageDetails(
          icon: Icon(Icons.warning,
              color: Colors.white.withOpacity(0.87), size: 50),
          message: 'List Already Exist',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ONE_LEVEL_ELEVATION,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Create New List', style: kTitleStyle),
            Text('Give a name for this new list', style: kBodyStyle),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: 120,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: kTextBorderColor, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                child: TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintText: 'Name',
                      hintStyle: kSubtitle1,
                      border: InputBorder.none,
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    style: TextStyle(
                      color: Hexcolor('#DEDEDE'),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvatica',
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (val) => _addList(context)),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: kTextBorderColor, width: 0.5))),
              // padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DialogButtons(
                      title: 'Cancel',
                      onTap: () {
                        textEditingController.clear();
                        Navigator.of(context).pop();
                      },
                      leftButton: true),
                  DialogButtons(
                      title: 'Create', onTap: () => _addList(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
