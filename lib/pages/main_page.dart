import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/most_watched_page.dart';
import 'package:e_movies/pages/movies_screen.dart';
import 'package:e_movies/pages/tv_screen.dart';
import 'package:e_movies/widgets/bottom_tabs.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main-page';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectedIndex = 0;


  @override
  initState() {
    super.initState();
    // Future.delayed(Duration.zero).then((value) => {
    //   Provider.of<Movies>(context, listen: false).fetch(),
    // });
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: _selectedIndex,
    );
    _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: false,
        children: <Widget>[
          MoviesScreen(),
          TVScreen(),
          MostWatchedPage(),
        ],
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
      _tabController.index = newIndex;
      _pageController.jumpToPage(newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _background_image = Image.asset(
      'assets/images/background_image_1.jpg',
      fit: BoxFit.cover,
    );

    final transparentBackground = Container(
      color: TRRANSPARENT_BACKGROUND_COLOR,
    );

    final currentPage = BottomTabs(
      currentIndex: _selectedIndex,
      onTap: _onTap,      
    );

    // final bottom = Stack(
    //   children: [
    //     currentPage,
    //     Container(
    //       height: 56,
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
    //         child: Container(
    //           color: Colors.black.withOpacity(0),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    final _content = Scaffold(
      body: Stack(
        children: <Widget>[
          _buildTabContent(),
          currentPage,
          // bottom,
        ],
      ),
    );

    // return Stack(
    //   children: [
    //     _background_image,
    //     _content,
    //   ],
    // );    
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // _background_image,
          // transparentBackground,
          _content,
        ],
      ),
    );
  }
}
