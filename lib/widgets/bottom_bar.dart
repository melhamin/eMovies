import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  BottomBar({
    @required this.currentIndex,
    @required this.items,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(                        
        backgroundColor: Colors.black54,
        inactiveColor: Colors.white54,
        activeColor: Theme.of(context).accentColor,
        iconSize: 25,
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      );
  }
}
