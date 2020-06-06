import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final TabController controller;
  final ValueChanged<int> onTap;
  Tabs({this.controller, this.onTap});
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: controller,
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: TextStyle(
          fontFamily: 'Helvatica', fontSize: 16, color: Colors.white12),
      // backgroundColor: BASELINE_COLOR,
      // activeColor: Theme.of(context).accentColor,
      // inactiveColor: Colors.white38,

      onTap: onTap,
      // currentIndex: currentIndex,
      tabs: [
        Tab(
          icon: Text(
            'All',
            style: kTopBarTextStyle,
          ),
        ),
        Tab(
          icon: Text(
            'Movies',
            style: kTopBarTextStyle,
          ),
        ),
        Tab(
          icon: Text(
            'Series',
            style: kTopBarTextStyle,
          ),
        ),
        Tab(
          icon: Text(
            'People',
            style: kTopBarTextStyle,
          ),
        )
        // BottomNavigationBarItem(
        //   icon: Text(
        //     'Movies',
        //     style: kTopBarTextStyle,
        //   ),
        //   // icon: Icon(Icons.theaters),
        //   // backgroundColor: Theme.of(context).primaryColor,
        // ),
        // BottomNavigationBarItem(
        //   icon: Text(
        //     'TV',
        //     style: kTopBarTextStyle,
        //   ),
        //   // icon: Icon(Icons.tv),
        //   // backgroundColor: Theme.of(context).primaryColor,
        // ),
        // BottomNavigationBarItem(
        //   icon: Text(
        //     'People',
        //     style: kTopBarTextStyle,
        //   ),
        //   // icon: Icon(Icons.search),
        //   // backgroundColor: Theme.of(context).primaryColor,
        // ),
      ],
    );
  }
}