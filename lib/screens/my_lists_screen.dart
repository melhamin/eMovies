import 'package:e_movies/my_toast_message.dart';
import 'package:e_movies/screens/list_item_screen.dart';
import 'package:e_movies/screens/movies_lists.dart';
import 'package:e_movies/screens/search/tabs.dart';
import 'package:e_movies/screens/tv_lists.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/lists.dart';

enum MediaType {
  TV,
  Movie,
}

class MyListsScreen extends StatefulWidget {
  @override
  _MyListsScreenState createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;

  TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // /// Presents a modalBottomSheet and lets user to give a name and add new list
  // void _showAddDialog(BuildContext context) {
  //   showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, thisState) {
  //         return Container(
  //           padding: const EdgeInsets.only(left: 8, right: 8),
  //           decoration: BoxDecoration(
  //             color: BASELINE_COLOR,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(10),
  //               topRight: Radius.circular(10),
  //             ),
  //           ),
  //           height: MediaQuery.of(context).size.height * 0.85,
  //           child: ListView(
  //             children: <Widget>[
  //               Container(
  //                 height: 50,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     IconButton(
  //                       icon: Icon(
  //                         Icons.clear,
  //                         color: Theme.of(context).accentColor,
  //                       ),
  //                       onPressed: () {
  //                         _textEditingController.clear();
  //                         Navigator.of(context).pop();
  //                         setState(() {
  //                           _isEmpty = true;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 40),
  //               Center(
  //                 child: Text(
  //                   'Give your list a name.',
  //                   style: TextStyle(
  //                     color: Hexcolor('#DEDEDE'),
  //                     fontSize: 26,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: 'Helvatica',
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 40),
  //               Center(
  //                 child: Form(
  //                   key: _formKey,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                         bottom: BorderSide(color: Colors.white38),
  //                       ),
  //                     ),
  //                     child: TextFormField(
  //                         controller: _textEditingController,
  //                         textAlign: TextAlign.center,
  //                         autofocus: true,
  //                         onChanged: (val) {
  //                           thisState(() {
  //                             _isEmpty = val.isEmpty ? true : false;
  //                           });
  //                         },
  //                         // autovalidate: true,
  //                         cursorColor: Theme.of(context).accentColor,
  //                         style: TextStyle(
  //                           color: Hexcolor('#DEDEDE'),
  //                           fontSize: 24,
  //                           fontWeight: FontWeight.bold,
  //                           fontFamily: 'Helvatica',
  //                         ),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           errorBorder: InputBorder.none,
  //                           disabledBorder: InputBorder.none,
  //                           enabledBorder: InputBorder.none,
  //                           focusedBorder: InputBorder.none,
  //                           focusedErrorBorder: InputBorder.none,
  //                           errorStyle: TextStyle(
  //                             color: Colors.red,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             fontFamily: 'Helvatica',
  //                           ),
  //                         ),
  //                         textInputAction: TextInputAction.go,
  //                         keyboardAppearance: Brightness.dark,
  //                         validator: (value) {
  //                           if (value.isEmpty) return 'Please enter a name.';
  //                           return null;
  //                         },
  //                         onFieldSubmitted: (value) => _addList(context)),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 40),
  //               Center(
  //                   child: _isEmpty
  //                       ? FlatButton(
  //                           child: Text(
  //                             'Cancel',
  //                             style: kTitleStyle2,
  //                           ),
  //                           onPressed: () {
  //                             _textEditingController.clear();
  //                             Navigator.of(context).pop();
  //                             setState(() {
  //                               _isEmpty = true;
  //                             });
  //                           },
  //                         )
  //                       : Padding(
  //                           padding: const EdgeInsets.only(bottom: 20.0),
  //                           child: Center(
  //                             child: Container(
  //                               width: MediaQuery.of(context).size.width * 0.4,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(100),
  //                                 color: Theme.of(context).accentColor,
  //                               ),
  //                               child: FlatButton(
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(100)),
  //                                 child: Text('Create', style: kTitleStyle),
  //                                 onPressed: () => _addList(context),
  //                               ),
  //                             ),
  //                           ),
  //                         ))
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  void _changeTab(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      _tabController.index = newIndex;
    });
  }

  List<Widget> _getTabs() {
    return [
      Tab(
        child: Text('Movies', style: kTopBarTextStyle),
      ),
      Tab(
        icon: Text('TV Shows', style: kTopBarTextStyle),
      ),
    ];
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      
      children: [
        MoviesLists(),
        TVshowsLists(),
      ],
    );
  }

  Widget _buildTabBar() {
    return Tabs(
      tabs: _getTabs(),
      controller: _tabController,
      onTap: _changeTab,
      isScrollable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: NestedScrollView(
          headerSliverBuilder: (ctx, _) {
            return [
              SliverAppBar(
                backgroundColor: BASELINE_COLOR,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'My Lists',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvatica',
                        color: Colors.white.withOpacity(0.87)),
                  ),
                ),
                pinned: false,
              ),
              SliverAppBar(
                // elevation: 10,

                backgroundColor: BASELINE_COLOR,
                expandedHeight: 70,
                pinned: true,
                title: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 300,
                          child: _buildTabBar(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: _buildTabContent(),
        ),
      ),
    );
  }
}




