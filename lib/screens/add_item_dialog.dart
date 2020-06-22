import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AddItemDialog extends StatefulWidget {
  final GlobalKey<AnimatedListState> listKey;
  final MediaType mediaType;
  AddItemDialog({
    @required this.listKey,
    @required this.mediaType,
  });

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  GlobalKey<FormState> _formKey;
  TextEditingController _textEditingController;
  bool _isEmpty = true;

  bool _initLoaded = true;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // request focus to FormField after some delay.
    // used instead of (autoFocus = true)
    // autoFocus would cause a laggy animation when bottom sheet opens
    if (_initLoaded) {
      print('----------------');
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        _focusNode.requestFocus();
      });
      _initLoaded = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void unfocus() {
    _focusNode.unfocus();
  }

  /// Validates name of the new list and adds it to lists
  void _addList(BuildContext context) {
    if (!_formKey.currentState.validate()) return;

    bool result;
    // add to list according to the meida type
    if (widget.mediaType == MediaType.Movie) {
      result = Provider.of<Lists>(context, listen: false)
          .addNewMovieList(_textEditingController.text);
    } else {
      result = Provider.of<Lists>(context, listen: false)
          .addNewTVList(_textEditingController.text);
    }

    // if already exist show warning message
    if (!result)
      showWarningDialog();
    else {
      widget.listKey.currentState.insertItem(0,
          duration: Duration(milliseconds: 500)); // add item to animated list
      Navigator.of(context).pop();

      _textEditingController.clear();
      setState(() {
        _isEmpty = true;
      });
    }
  }

  void showWarningDialog() {
    ToastUtils.myToastMessage(
      context: context,
      alignment: Alignment.center,
      color: ONE_LEVEL_ELEVATION,
      duration: Duration(seconds: TOAST_DURATION),
      child: _buildToastMessageIcons(
          Icon(Icons.warning, color: Colors.white.withOpacity(0.87), size: 60),
          'List Already Exist!'),
    );
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

  void _onClose() {
    // unfocus textfield otherwise bottomsheet would be closed with laggy animation
    _focusNode.unfocus();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      _textEditingController.clear();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _onClose,
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
                    focusNode: _focusNode,
                    onChanged: (val) {
                      setState(() {
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
  }
}
