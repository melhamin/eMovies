import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  BottomTabBar({
    @required this.currentIndex,
    @required this.items,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(      
      backgroundColor: Colors.black54,
      inactiveColor: Color(0xff78909c),
      activeColor: Colors.white,
      iconSize: 30,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}
