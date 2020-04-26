import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  final TabController tabController;  
  final tabs;
  NavBar({
    this.tabController,    
    this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: APP_BAR_HEIGHT,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.black54,
          child: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).accentColor,
            ),
            controller: tabController,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}