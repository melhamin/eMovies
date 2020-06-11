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
                  padding: const EdgeInsets.only(top: 15.0),
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




