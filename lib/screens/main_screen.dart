import 'dart:ui';

import 'package:e_movies/providers/lists.dart';
import 'package:flutter/material.dart';

import 'package:e_movies/screens/movie/movies_screen.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/search/search_screen.dart';
import 'package:e_movies/screens/tv/tv_screen.dart';
import 'package:e_movies/widgets/bottom_tabs.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  static const routeName = '/main-page';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectedIndex = 0;


  @override
  initState() {
    super.initState();

    // load lists    
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Lists>(context, listen: false).loadLists();
    });
    _tabController = TabController(
      vsync: this,
      length: 4,
      initialIndex: _selectedIndex,
    );
    _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
  
    // _tabController.addListener(() { 
    //   if(_tabController.indexIsChanging) {
    //     FocusScope.of(context).nextFocus();
    //   }
    // });
  }

  @override 
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();    
    super.dispose();
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,        
        children: <Widget>[
          MoviesScreen(),
          TVScreen(),
          SearchScreen(),
          MyListsScreen(),
        ],
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
      // _tabController.index = newIndex;
      _pageController.jumpToPage(newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final _background_image = Image.asset(
    //   'assets/images/background_image_1.jpg',
    //   fit: BoxFit.cover,
    // );

    // final transparentBackground = Container(
    //   color: TRRANSPARENT_BACKGROUND_COLOR,
    // );

    final currentPage = BottomTabs(
      currentIndex: _selectedIndex,
      onTap: _onTap,      
    );

    final _content = Scaffold( 
      resizeToAvoidBottomInset: false,     
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          _buildTabContent(),
          currentPage,
          // bottom,
        ],
      ),
    );  
    return SafeArea(
      child: _content,
    );
  }
}