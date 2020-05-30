import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/pages/movie/trending_movies_screen.dart';
import 'package:e_movies/pages/movie/top_rated_screen.dart';
import 'package:e_movies/pages/movie/upcoming_screen.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/movie_item.dart' as movieWid;
import 'package:e_movies/consts/consts.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool _initLoaded = true;
  bool _isFetching = true;
  TabController _tabController;

  bool showTitle = false;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     if (_scrollController.offset > 21) {
    //       // 21 the font size
    //       setState(() {
    //         showTitle = true;
    //       });
    //     }
    //     if (_scrollController.offset < 21) {
    //       setState(() {
    //         showTitle = false;
    //       });
    //     }
    //   });
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<Movies>(context, listen: false).fetchTrending(1);
      Provider.of<Movies>(context, listen: false).fetchUpcoming(1);
      Provider.of<Movies>(context, listen: false)
          .fetchTopRated(1)
          .then((value) {
        setState(() {
          _isFetching = false;
        });
      });
    }
    _initLoaded = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title, Function onTap,
      [bool withSeeAll = true]) {
    return Padding(
      padding: const EdgeInsets.only(
        left: LEFT_PADDING,
        right: LEFT_PADDING,
        top: 30,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kTitleStyle),
          if (withSeeAll)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text('See All', style: kSeeAll)),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 18,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Route _buildRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trending = Provider.of<Movies>(context).trending;
    final upcoming = Provider.of<Movies>(context).upcoming;
    final topRated = Provider.of<Movies>(context).topRated;

    return SafeArea(
      child: Scaffold(
      // NestedScrollView(
      //   headerSliverBuilder: (ctx, boo) {
      //     return [
      //       SliverAppBar(
      //         backgroundColor: showTitle ? ONE_LEVEL_ELEVATION : BASELINE_COLOR,
      //         pinned: true,
      //         centerTitle: true,
      //         expandedHeight: 50,
      //         title:
      //             showTitle ? Text('Discover', style: kTitleStyle) : Text(''),
      //       ),
      //     ];
      //   },
        body: LayoutBuilder(
          builder: (ctx, constraints) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                   bottom: kToolbarHeight),
              controller: _scrollController,
              children: <Widget>[
                // SizedBox(height: 20,),
                // Padding(
                //   padding: const EdgeInsets.only(left: LEFT_PADDING),
                //   child: Text('Discover', style: TextStyle(
                //     color: Colors.white.withOpacity(0.87),
                //     fontFamily: 'Helvatica',
                //     fontSize: 24,                    
                //     fontWeight: FontWeight.bold,
                //   )),
                // ),
                _buildSectionTitle('Trending', () {
                  Navigator.of(context)
                      .push(_buildRoute(TrendingMoviesScreen()));
                }),
                Container(
                    height: constraints.maxHeight * 0.35,
                    child: _isFetching
                        ? SpinKitCircle(
                            color: Theme.of(context).accentColor,
                            size: 21,
                          )
                        : Grid(movies: trending, storageKey: 'Movie-Trending',)),
                _buildSectionTitle('Upcoming', () {
                  Navigator.of(context).push(_buildRoute(UpcomingScreen()));
                }),
                Container(
                    height: constraints.maxHeight * 0.35,
                    child: _isFetching
                        ? SpinKitCircle(
                            color: Theme.of(context).accentColor,
                            size: 21,
                          )
                        : Grid(movies: upcoming, storageKey: 'Movie-Upcoming',)),
                _buildSectionTitle('Top Rated', () {
                  Navigator.of(context).push(_buildRoute(TopRated()));
                }),
                Container(
                    height: constraints.maxHeight * 0.35,
                    child: _isFetching
                        ? SpinKitCircle(
                            color: Theme.of(context).accentColor,
                            size: 21,
                          )
                        : Grid(movies: topRated, storageKey: 'Movie-Top_Rated',)),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Grid extends StatelessWidget {
  final movies;
  final String storageKey;
  Grid({this.movies, this.storageKey});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey(storageKey),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      itemCount: movies.length > 20 ? 20 : movies.length,
      itemBuilder: (context, index) {
        return movieWid.MovieItem(
          item: movies[index],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
        mainAxisSpacing: 10,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}

/***
 * LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSectionTitle('Genres', () {
              Navigator.of(context).push(_buildRoute(TrendingMoviesScreen()));
            }, false),
            Container(
                height: constraints.maxHeight * 0.25,
                child: _isFetching
                    ? SpinKitCircle(
                        color: Theme.of(context).accentColor,
                        size: 21,
                      )
                    : GenreGrid(
                        itemsList: MOVIE_GENRE_DETAILS,
                        mediaType: 0,
                      )),
            _buildSectionTitle('Trending', () {
              Navigator.of(context).push(_buildRoute(TrendingMoviesScreen()));
            }),
            Container(
                height: constraints.maxHeight * 0.35,
                child: _isFetching
                    ? SpinKitCircle(
                        color: Theme.of(context).accentColor,
                        size: 21,
                      )
                    : Grid(movies: trending)),
            _buildSectionTitle('Upcoming', () {
              Navigator.of(context).push(_buildRoute(UpcomingScreen()));
            }),
            Container(
                height: constraints.maxHeight * 0.35,
                child: _isFetching
                    ? SpinKitCircle(
                        color: Theme.of(context).accentColor,
                        size: 21,
                      )
                    : Grid(movies: upcoming)),
            _buildSectionTitle('Top Rated', () {
              Navigator.of(context).push(_buildRoute(TopRated()));
            }),
            Container(
                height: constraints.maxHeight * 0.35,
                child: _isFetching
                    ? SpinKitCircle(
                        color: Theme.of(context).accentColor,
                        size: 21,
                      )
                    : Grid(movies: topRated)),
          ],
        );
      },
    ),
 */
