import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final TabController controller;
  final ValueChanged<int> onTap;
  final List<Widget> tabs;
  final bool isScrollable;
  Tabs({this.tabs, this.controller, this.onTap, this.isScrollable = true});
  @override
  Widget build(BuildContext context) {
    return TabBar(      
       isScrollable: isScrollable,      
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.only(right: 35),
      labelPadding: EdgeInsets.only(right: 35),
      controller: controller,
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: TextStyle(
          fontFamily: 'Helvatica', fontSize: 16, color: Colors.white12),
      onTap: onTap,      
      tabs: tabs                    
    );
  }
}