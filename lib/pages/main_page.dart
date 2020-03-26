import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/widgets/bottom_tab_bar.dart';
import 'package:e_movies/pages/favorites_page.dart';
import 'package:e_movies/widgets/e_app_bar.dart';
import 'all_movies_page.dart';
import '../providers/movies.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 1;  

  @override
  initState() {
    super.initState();
    // Future.delayed(Duration.zero).then((value) => {
    //   Provider.of<Movies>(context, listen: false).fetch(),
    // });
    _tabController = TabController(vsync: this, length: 2);
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          AllMoviesPage(),
          FavoritesPage(),
        ],
      ),
    );
  }

  void _onTap(int newIndex) {    
    setState(() {
      _selectedIndex = newIndex;
      _tabController.index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _background_image = Image.asset(
      'assets/images/background_image.jpg',
      fit: BoxFit.cover,
    );

    final currentPage = _BottomTabs(
      currentIndex: _selectedIndex,
      onTap: _onTap,
    );

    final _content = Scaffold(
      appBar: PreferredSize(
        child: EAppBar(),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Stack(
        children: <Widget>[
          _buildTabContent(),
          currentPage,         
        ],
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _background_image,
        _content,
      ],
    );
  }
}

class _BottomTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  _BottomTabs({
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BottomTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Trending',
              style: TextStyle(fontSize: 12),
            ),
            icon: Icon(Icons.theaters),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text(
              'Favorites',
              style: TextStyle(fontSize: 12),
            ),
            icon: Icon(Icons.favorite),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
