

import 'package:e_movies/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './bottom_bar.dart';

class BottomTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomTabs({
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: BottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
        BottomNavigationBarItem(
          title: Text(
            'Discover',
            style: kBottomBarTextStyle,
          ),
          icon: Icon(Icons.home),          
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          title: Text(
            'Search',
            style: kBottomBarTextStyle,
          ),
          icon: Icon(CupertinoIcons.search),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          title: Text(
            'Cinemas',
            style: kBottomBarTextStyle,
          ),
          icon: Icon(CupertinoIcons.location),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          title: Text(
            'Lists',
            style: kBottomBarTextStyle,
          ),
          icon: Icon(Icons.list),
          backgroundColor: Theme.of(context).primaryColor,
        ),
          ],
        ),
    );
  }
}