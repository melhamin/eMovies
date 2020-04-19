import 'dart:ui';

import 'package:e_movies/pages/genres_page.dart';
import 'package:e_movies/pages/trending_movies_page.dart';
import 'package:e_movies/pages/upcoming_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // int _selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  void _onTap(int index) {
    // setState(() {
    //   _selectedIndex = index;
    //   _tabController.index = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final navBar = Align(
      alignment: Alignment.topCenter,
      child: NavBar(
        onTap: _onTap,
        tabController: _tabController,
      ),
    );

    final content = TabBarView(            
      controller: _tabController,
      children: [
        GenresPage(),
        TrendingMoviesPage(),
        UpcomingMoviesPage(),        
      ],

      // appBar: PreferredSize(
      //   child: NavBar(tabController: _tabController, onTap: _onTap),
      //   preferredSize: Size.fromHeight(kToolbarHeight),
      // ),
    );

    return SafeArea(      
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          navBar,
        ],
      ),
      // child: Scaffold(
      //   // appBar: PreferredSize(
      //   //   child: NavBar(tabController: _tabController, onTap: _onTap),
      //   //   preferredSize: Size.fromHeight(kToolbarHeight),
      //   // ),
      //   body: TabBarView(
      //     controller: _tabController,
      //     children: [
      //       TrendingMoviesPage(),
      //       UpcomingMoviesPage(),
      //       UpcomingMoviesPage(),
      //     ],
      //   ),
      // ),
    );
  }
}

class NavBar extends StatelessWidget {
  final TabController tabController;
  final Function onTap;
  NavBar({this.tabController, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
              tabs: [                                
                Text('Genres', style: TextStyle(color: Colors.white)),
                Text('Trending', style: TextStyle(color: Colors.white)),
                Text('Upcming',  style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
      ),
    );
  }
}
