import 'dart:ui';

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
            'Films',
            style: TextStyle(fontSize: 14),
          ),
          icon: Icon(Icons.theaters),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          title: Text(
            'TV',
            style: TextStyle(fontSize:14),
          ),
          icon: Icon(Icons.tv),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          title: Text(
            'Most Watched',
            style: TextStyle(fontSize: 14),
          ),
          icon: Icon(Icons.watch_later),
          backgroundColor: Theme.of(context).primaryColor,
        ),
          ],
        ),
    );
  }
}