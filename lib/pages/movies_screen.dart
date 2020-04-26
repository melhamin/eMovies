import 'package:e_movies/pages/genres_page.dart';
import 'package:e_movies/pages/in_theaters_page.dart';
import 'package:e_movies/pages/top_rated_page.dart';
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final navBar = Align(
      alignment: Alignment.topCenter,
      child: NavBar(
        // onTap: _onTap,
        tabController: _tabController,
        tabs: [
          Tab(
              child:
                  Text('Genres', style: Theme.of(context).textTheme.headline5)),
          Tab(
              child: Text('In Theaters',
                  style: Theme.of(context).textTheme.headline5)),
          Tab(
              child: Text('Top Rated',
                  style: Theme.of(context).textTheme.headline5)),
        ],
      ),
    );

    final content = TabBarView(
      controller: _tabController,
      children: [
        GenresPage(),
        InTheaters(),
        TopRated(),
      ],  
    );

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          navBar,
        ],
      ),  
    );
  }
}


