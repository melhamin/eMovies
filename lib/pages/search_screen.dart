import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/search.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/genre_tile.dart';
import 'package:e_movies/widgets/movie/movie_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _searchController;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    if(_searchQuery.isEmpty)
    Provider.of<Search>(context, listen: false).clearMovies();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose    
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: _searchQuery.isEmpty
          ? null
          : SpinKitCircle(
              size: 21,
              color: Theme.of(context).accentColor,
            ),
    );
  }

  Widget _buildNotSearching() {
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
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
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
                    Text('Movies, Tv shows, People',
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
        padding:
            const EdgeInsets.only(bottom: kToolbarHeight, left: 20, right: 20),
        children: <Widget>[
          Text('Browse All', style: kTitleStyle2),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }

  Widget _buildIsSearhing() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // elevation: 10,
        // bottom: PreferredSize(
        //   child: Container(color: BASELINE_COLOR),
        //   preferredSize: Size.fromHeight(5),
        // ),
        backgroundColor: Hexcolor('#151515'),
        title: Container(
          height: 35,          
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: ONE_LEVEL_ELEVATION,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            autofocus: true,
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
              // height: 1.5,
              color: Colors.white.withOpacity(0.87),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel', style: kBodyStyle2),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
              });
              Provider.of<Search>(context, listen: false).clearMovies();
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: FutureBuilder(
          future: Provider.of<Search>(context).searchMovies(_searchQuery, 1),
          builder: (_, snapshot) {
            var movies = Provider.of<Search>(context).movies;
            // print('query ---------> $_searchQuery');
            return snapshot.connectionState == ConnectionState.waiting
                ? _buildLoadingIndicator(context)
                : GridView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kToolbarHeight, left: 10, right: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: movies.length,
                    itemBuilder: (ctx, i) {
                      return MovieItem(
                        item: movies[i],
                        withoutDetails: true,
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 2,
                    ),
                  );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: !_isSearching ? _buildNotSearching() : _buildIsSearhing(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/**
 * 
 * Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ONE_LEVEL_ELEVATION,
          title: Container(
            child: TextField(
              cursorColor: Theme.of(context).accentColor,
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search movies & TV shows...',
                hintStyle: const TextStyle(color: Colors.white30),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              // onChanged: _updateSearchQuery,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      ),
 */
