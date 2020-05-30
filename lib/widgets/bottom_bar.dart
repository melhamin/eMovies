
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  BottomBar({
    @required this.currentIndex,
    @required this.items,
    @required this.onTap,
  });

  bool _isKeyboardVisible(BuildContext context) {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  Widget build(BuildContext context) {    
    // In order to avoid showing tab bar when keyboard is opened
    return _isKeyboardVisible(context) ? SizedBox() : 
     CupertinoTabBar(                        
        backgroundColor:Hexcolor('#BF303030'),
        inactiveColor: Colors.white70,
        activeColor: Theme.of(context).accentColor,
        iconSize: 35,
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      );
  }
}

