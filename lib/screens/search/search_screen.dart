import 'package:e_movies/screens/search/actors_result.dart';
import 'package:e_movies/screens/search/all_results.dart';
import 'package:e_movies/screens/search/movies_result.dart';
import 'package:e_movies/screens/search/tabs.dart';
import 'package:e_movies/screens/search/tv_shows_result.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/search.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/genre_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isSearching = false;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Search>(context, listen: false).loadSearchHistory();
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child:
          !_isSearching ? NotSearching(toggleSearch) : Searching(toggleSearch),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Searching extends StatefulWidget {
  final Function toggleSearch;
  Searching(this.toggleSearch);
  @override
  _SearchingState createState() => _SearchingState();
}

class _SearchingState extends State<Searching>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController;
  TabController _tabController;
  int currentIndex = 1;

  // LoaderStatus _loaderStatus = LoaderStatus.STABLE;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: '');
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    // if (_searchController.text.isEmpty) {
    //   Provider.of<Search>(context, listen: false).clearMovies();
    // Provider.of<Search>(context, listen: false).clearSeries();
    // Provider.of<Search>(context, listen: false).clearPeople();
    // }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTabContent() {
    return TabBarView(
      // physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        AllResults(
          searchController: _searchController,
          isLoading: _isFetching,
          handleTabChange: _onTap,
        ),
        MoviesResult(
            searchController: _searchController, isLoading: _isFetching),
        TVShowsResult(
            searchController: _searchController, isLoading: _isFetching),
        ActorsResult(
            searchController: _searchController, isLoading: _isFetching),
      ],
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      _tabController.index = newIndex;
    });
  }

  Future<void> _fetch(String query) async {
    Provider.of<Search>(context, listen: false)
        .searchPerson(query, 1)
        .then((value) {
      Provider.of<Search>(context, listen: false)
          .searchMovies(query, 1)
          .then((value) {
        Provider.of<Search>(context, listen: false).searchTVShows(query, 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Tabs(
      controller: _tabController,
      // currentIndex: currentIndex,
      onTap: _onTap,
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // elevation: 10,
        bottom: PreferredSize(
          child: Container(
            // margin: const EdgeInsets.only(right: 100),
            // padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(),
            height: 45,
            child: currentPage,
          ),
          preferredSize: Size.fromHeight(40),
        ),
        backgroundColor: Hexcolor('#151515'),
        title: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: TWO_LEVEL_ELEVATION,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 18,
                fontFamily: 'Helvatica',
              ),
            ),
            style: TextStyle(
              fontFamily: 'Helvatica',
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              height: 0.9,
              color: Colors.white.withOpacity(0.87),
            ),
            onChanged: (value) {
              // set _isFetching = true to show loading indcator
              setState(() {
                _isFetching = true;
              });
              // Provider.of<Search>(context, listen: false)
              //     .searchMovies(value, 1)

              _fetch(value).then((value) {
                setState(() {
                  _isFetching = false;
                });
              });
              //  Provider.of<Search>(context, listen: false)
              //     .searchTVShows(value, 1);
              //     Provider.of<Search>(context, listen: false)
              //     .searchPerson(value, 1);
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel', style: kTopBarTextStyle),
            onPressed: () {
              setState(() {
                widget.toggleSearch();
                // _searchQuery = '';
                _searchController.text = '';
              });
              Provider.of<Search>(context, listen: false).clearMovies();
              Provider.of<Search>(context, listen: false).clearPeople();
              Provider.of<Search>(context, listen: false).clearSeries();
            },
          ),
        ],
      ),
      body: _buildTabContent(),
    );
  }
}

class NotSearching extends StatelessWidget {
  final Function toggleSearch;
  NotSearching(this.toggleSearch);

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: LEFT_PADDING,
        right: LEFT_PADDING,
        // top: 30,
        bottom: 10,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.12), width: 1))
        ),
        child: Text(title, style: TextStyle(
          fontFamily: 'Helvatica',
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.87)          
        )),
        //     if (withSeeAll)
        //       GestureDetector(
        //         onTap: onTap,
        //         child: Row(
        //           children: [
        //             Padding(
        //                 padding: EdgeInsets.only(top: 3),
        //                 child: Text('See All', style: kSeeAll)),
        //             SizedBox(width: 3),
        //             Icon(
        //               Icons.arrow_forward_ios,
        //               color: Colors.white.withOpacity(0.6),
        //               size: 18,
        //             ),
        //           ],
        //         ),
        //       ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (ctx, i) {
        return [
          SliverAppBar(
            backgroundColor: BASELINE_COLOR,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Search',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvatica',
                    color: Colors.white.withOpacity(0.87)),
              ),
            ),
            pinned: false,
          ),
          SliverAppBar(
            backgroundColor: BASELINE_COLOR,
            expandedHeight: 80,
            bottom: PreferredSize(
              child: Container(color: BASELINE_COLOR),
              preferredSize: Size.fromHeight(10),
            ),
            pinned: true,
            title: GestureDetector(
              onTap: () => toggleSearch(),
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Hexcolor('#DEDEDE'),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search, color: Hexcolor('#010101')),
                    SizedBox(width: 10),
                    Text('Movies, TV shows, People',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Helvatica',
                          color: Hexcolor('#010101'),
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: kToolbarHeight),
        children: <Widget>[
          _buildSectionTitle(context, 'Movies'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING, vertical: 10),
            child: Text('Browse All', style: kSubtitle1),
          ),          
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
              physics: const BouncingScrollPhysics(),
              itemCount: MOVIE_GENRE_DETAILS.length,
              itemBuilder: (ctx, i) {
                return GenreTile(
                  imageUrl: MOVIE_GENRE_DETAILS[i]['imageUrl'],
                  genreId: MOVIE_GENRE_DETAILS[i]['genreId'],
                  title: MOVIE_GENRE_DETAILS[i]['title'],
                  mediaType: 0,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2 / 3,
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
