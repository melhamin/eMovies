import 'package:e_movies/screens/my_lists_screen.dart';
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
            handleTabChange: _onTap),
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

  List<Widget> _getTabs() {
    return [
      Tab(icon: Text('All')),
      Tab(icon: Text('Movies')),
      Tab(icon: Text('TV shows')),
      Tab(icon: Text('People')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Tabs(
      tabs: _getTabs(),
      controller: _tabController,
      onTap: _onTap,
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: TWO_LEVEL_ELEVATION,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        autofocus: true,
                        cursorColor: Theme.of(context).accentColor,
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.87),
                            fontSize: 18,
                            
                          ),
                        ),
                        style: TextStyle(
                          
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
                  ),
                  Flexible(
                    flex: 1,
                    child: FlatButton(
                      child: Text(
                        'Cancel',
                        style: kSelectedTabStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.toggleSearch();
                          // _searchQuery = '';
                          _searchController.text = '';
                        });
                        Provider.of<Search>(context, listen: false)
                            .clearMovies();
                        Provider.of<Search>(context, listen: false)
                            .clearPeople();
                        Provider.of<Search>(context, listen: false)
                            .clearSeries();
                      },
                    ),
                  ),
                ],
              ),
              PreferredSize(
                child: currentPage,
                preferredSize: Size.fromHeight(40),
              ),
            ],
          ),
        ),
      ),
//      AppBar(
//        bottom: PreferredSize(
//          child: Container(
//            width: double.infinity,
//            margin: const EdgeInsets.only(left: LEFT_PADDING + 5),
//            decoration: BoxDecoration(),
//            child: currentPage,
//          ),
//          preferredSize: Size.fromHeight(40),
//        ),
//        backgroundColor: Hexcolor('#151515'),
//        title: Container(
//          height: 35,
//          padding: const EdgeInsets.only(left: 10),
//          decoration: BoxDecoration(
//            color: TWO_LEVEL_ELEVATION,
//            borderRadius: BorderRadius.circular(10),
//          ),
//          child: TextField(
//            autofocus: true,
//            controller: _searchController,
//            textAlignVertical: TextAlignVertical.center,
//            textInputAction: TextInputAction.go,
//            decoration: InputDecoration(
//              border: InputBorder.none,
//              hintText: 'Search',
//              hintStyle: TextStyle(
//                color: Colors.white.withOpacity(0.87),
//                fontSize: 18,
//                
//              ),
//            ),
//            style: TextStyle(
//              
//              fontSize: 18,
//              // fontWeight: FontWeight.bold,
//              height: 0.9,
//              color: Colors.white.withOpacity(0.87),
//            ),
//            onChanged: (value) {
//              // set _isFetching = true to show loading indcator
//              setState(() {
//                _isFetching = true;
//              });
//              // Provider.of<Search>(context, listen: false)
//              //     .searchMovies(value, 1)
//
//              _fetch(value).then((value) {
//                setState(() {
//                  _isFetching = false;
//                });
//              });
//              //  Provider.of<Search>(context, listen: false)
//              //     .searchTVShows(value, 1);
//              //     Provider.of<Search>(context, listen: false)
//              //     .searchPerson(value, 1);
//            },
//          ),
//        ),
//        actions: <Widget>[
//          FlatButton(
//            child: Text('Cancel', style: kTopBarTextStyle),
//            onPressed: () {
//              setState(() {
//                widget.toggleSearch();
//                // _searchQuery = '';
//                _searchController.text = '';
//              });
//              Provider.of<Search>(context, listen: false).clearMovies();
//              Provider.of<Search>(context, listen: false).clearPeople();
//              Provider.of<Search>(context, listen: false).clearSeries();
//            },
//          ),
//        ],
//      ),
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
        left: DEFAULT_PADDING,
        right: DEFAULT_PADDING,
        // top: 30,
        bottom: 10,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.white.withOpacity(0.12), width: 1))),
        child: Text(title,
            style: TextStyle(
                
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.87))),
      ),
    );
  }

  Widget _buildBrowsAllGenres(MediaType mediaType) {
    final genres =
        mediaType == MediaType.Movie ? MOVIE_GENRE_DETAILS : TV_GENRE_DETAILS;
    // print('all genres -----------> $genres');
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: genres.length,
      itemBuilder: (ctx, i) {
        return GenreTile(
          imageUrl: genres[i]['imageUrl'],
          genreId: genres[i]['genreId'],
          title: genres[i]['title'],
          mediaType: mediaType,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      scrollDirection: Axis.vertical,
    );
  }

  Map<String, dynamic> getGenreItem(int id, MediaType mediaType) {
    if (mediaType == MediaType.TV) {
      int index =
          TV_GENRE_DETAILS.indexWhere((element) => element['genreId'] == id);
      return TV_GENRE_DETAILS[index];
    } else {
      int index =
          MOVIE_GENRE_DETAILS.indexWhere((element) => element['genreId'] == id);
      return MOVIE_GENRE_DETAILS[index];
    }
  }

  Widget _buildMyTopGenres(
      BuildContext context, List<int> genres, MediaType mediaType) {
    // print('topTVGenres =========> $topTVGenres');
    return Container(
      // height: MediaQuery.of(context).size.height * 0.4 -
      // 30, // main and cross axis spacing
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
        itemCount: genres.length,
        itemBuilder: (_, i) {
          final item = getGenreItem(genres[i], mediaType);
          return GenreTile(
            imageUrl: item['imageUrl'],
            genreId: item['genreId'],
            title: item['title'],
            mediaType: mediaType,
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING, vertical: 10),
      child: Text(title, style: kSubtitle1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topMovieGenres = Provider.of<Search>(context).topMovieGenres;
    final topTVGenres = Provider.of<Search>(context).topTVGenres;
    return NestedScrollView(
      headerSliverBuilder: (ctx, i) {
        return [
          SliverAppBar(
            backgroundColor: BASELINE_COLOR,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Search',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    
                    color: Colors.white.withOpacity(0.87)),
              ),
            ),
            pinned: false,
            floating: false,
          ),
          SliverAppBar(
            backgroundColor: BASELINE_COLOR,
            expandedHeight: 80,
            bottom: PreferredSize(
              child: Container(color: BASELINE_COLOR),
              preferredSize: Size.fromHeight(10),
            ),
            pinned: true,
            floating: false,
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
        
        padding: const EdgeInsets.only(bottom: kToolbarHeight),
        children: <Widget>[
         _buildSectionTitle(context, 'Movies'),          
          if (topMovieGenres.isNotEmpty) ...[
            _buildTitle('Your Top Genres'),
            _buildMyTopGenres(context, topMovieGenres, MediaType.Movie),
          ],
          SizedBox(height: 20),
          _buildTitle('All Genres'),
          _buildBrowsAllGenres(MediaType.Movie),
          SizedBox(height: 20),
          _buildSectionTitle(context, 'TV Shows'),
          if (topTVGenres.isNotEmpty) ...[
            _buildTitle('Your Top Genres'),
            _buildMyTopGenres(context, topTVGenres, MediaType.TV),
          ],
          SizedBox(height: 20),
          _buildTitle('All Genres'),
          _buildBrowsAllGenres(MediaType.TV),
        ],
      ),
    );
  }
}
