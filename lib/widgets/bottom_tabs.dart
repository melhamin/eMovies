

import 'package:e_movies/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          // title: Text(
          //   'Discover',
          //   style: kBottomBarTextStyle,
          // ),
          // activeIcon:Icon(Icons.home),       
          // icon: Icon(CupertinoIcons.home),
          icon: SvgPicture.asset('assets/svg/home.svg', width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
          activeIcon: SvgPicture.asset('assets/svg/Home_solid.svg', width: 25, height: 25, color: Theme.of(context).accentColor),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          // title: Text(
          //   'Search',
          //   style: kBottomBarTextStyle,
          // ),
          // icon: Icon(CupertinoIcons.search),
          icon: SvgPicture.asset('assets/svg/Search.svg', width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
          activeIcon: SvgPicture.asset('assets/svg/Search.svg', width: 25, height: 25, color: Theme.of(context).accentColor),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          // title: Text(
          //   'Lists',
          //   style: kBottomBarTextStyle,
          // ),
          icon: SvgPicture.asset('assets/svg/list.svg', width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
          activeIcon: SvgPicture.asset('assets/svg/list_solid.svg', width: 25, height: 25, color: Theme.of(context).accentColor),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          // title: Text(
          //   'Cinemas',
          //   style: kBottomBarTextStyle,
          // ),
          icon: Icon(CupertinoIcons.location),
          activeIcon: Icon(CupertinoIcons.location_solid),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          // title: Text(
          //   'Account',
          //   style: kBottomBarTextStyle,
          // ),
          // icon: Icon(CupertinoIcons.profile_circled),
          icon: SvgPicture.asset('assets/svg/Profile.svg', width: 25, height: 25, color: Colors.white.withOpacity(0.7)),
          activeIcon: SvgPicture.asset('assets/svg/Profile.svg', width: 25, height: 25, color: Theme.of(context).accentColor),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        
          ],
        ),
    );
  }
}