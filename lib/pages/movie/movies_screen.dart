import 'package:e_movies/pages/genres_screen.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/pages/movie/in_theaters_screen.dart';
import 'package:e_movies/pages/movie/top_rated_screen.dart';
import 'package:e_movies/pages/movie/upcoming_screen.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/widgets/genre_tile.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/movie_item.dart' as movieWid;

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  bool _initLoaded = true;
  bool _isFetching = true;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<Movies>(context, listen: false).fetchInTheaters(1);
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

  Widget _buildNavBar() {
    return NavBar(
      tabController: _tabController,
      tabs: [
        Tab(
            icon: Text(
          'discover',
          style: kTitleStyle2,
        )),
        Tab(
            icon: Text(
          'Genres',
          style: kTitleStyle2,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final inTheater = Provider.of<Movies>(context).inTheaters;
    final upcoming = Provider.of<Movies>(context).upcoming;
    final topRated = Provider.of<Movies>(context).topRated;

    final content = TabBarView(
      controller: _tabController,
      children: [
        DiscoverTab(
          inTheater: inTheater,
          isFetching: _isFetching,
          topRated: topRated,
          upcoming: upcoming,
        ),
        GenresScreen(),
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _buildNavBar(),
        ),
        body: content,
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({
    Key key,
    @required bool isFetching,
    @required this.inTheater,
    @required this.upcoming,
    @required this.topRated,
  })  : _isFetching = isFetching,
        super(key: key);

  final bool _isFetching;
  final List<MovieItem> inTheater;
  final List<MovieItem> upcoming;
  final List<MovieItem> topRated;

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
                    color: Hexcolor('#DEDEDE'),
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

  Widget _buildGenres() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      key: PageStorageKey('GenresPageGrid'),
      physics: BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemCount: MOVIE_GENRE_DETAILS.length,
      itemBuilder: (context, i) {
        return GenreTile(
          imageUrl: MOVIE_GENRE_DETAILS[i]['imageUrl'],
          genreId: MOVIE_GENRE_DETAILS[i]['genreId'],
          title: MOVIE_GENRE_DETAILS[i]['title'],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2 / 3,
        // mainAxisSpacing: 10,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          child: Column(
            children: [
              _buildSectionTitle('In Theaters', () {
                Navigator.of(context).push(_buildRoute(InTheaters()));
              }),
              Container(
                  height: constraints.maxHeight * 0.5,
                  child: _isFetching
                      ? SpinKitCircle(
                          color: Theme.of(context).accentColor,
                          size: 21,
                        )
                      : Grid(movies: inTheater)),
              _buildSectionTitle('Upcoming', () {
                Navigator.of(context).push(_buildRoute(UpcomingScreen()));
              }),
              Container(
                  height: constraints.maxHeight * 0.5,
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
                  height: constraints.maxHeight * 0.5,
                  child: _isFetching
                      ? SpinKitCircle(
                          color: Theme.of(context).accentColor,
                          size: 21,
                        )
                      : Grid(movies: topRated)),
            ],
          ),
        );
      },
    );
  }
}

class Grid extends StatelessWidget {
  final movies;
  Grid({this.movies});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey('Grid'),
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      itemCount: movies.length > 20 ? 20 : movies.length,
      itemBuilder: (context, index) {
        return movieWid.MovieItem(
          movie: movies[index],
          withFooter: true,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2,
        // mainAxisSpacing: 5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}
