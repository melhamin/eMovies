import 'package:e_movies/pages/tv/on_air_screen.dart';
import 'package:e_movies/pages/tv/popular_screen.dart';
import 'package:e_movies/pages/tv/top_rated_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/widgets/genre_tile.dart';
import 'package:e_movies/pages/movie/in_theaters_screen.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/tv/tv_item.dart' as tvWid;
import 'package:e_movies/providers/tv.dart';

class TVScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<TVScreen> {
  bool _initLoaded = true;
  bool _isFetching = true;

  static const SECTION_HEIGHT = 0.45;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).fetchPopular(1);
      Provider.of<TV>(context, listen: false).fetchOnAirToday(1);
      Provider.of<TV>(context, listen: false).fetchTopRated(1).then((value) {
        setState(() {
          _isFetching = false;
          _initLoaded = false;
        });
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      key: PageStorageKey('GenresGrid'),
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
    // super.build(context);
    final popular = Provider.of<TV>(context).popular;
    final onAirToday = Provider.of<TV>(context).onAirToday;
    final topRated = Provider.of<TV>(context).topRated;  
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: kToolbarHeight),
              child: Column(
                children: [
                  _buildSectionTitle('Genres', null, false),
                  Container(
                    // color: Colors.red
                    height: constraints.maxHeight * 0.25,
                    child: _buildGenres(),
                  ),
                  _buildSectionTitle('Popular', () {
                    Navigator.of(context).push(_buildRoute(PopularScreen()));
                  }),
                  Container(
                      height: constraints.maxHeight * SECTION_HEIGHT,
                      child: _isFetching
                          ? SpinKitCircle(
                              color: Theme.of(context).accentColor,
                              size: 21,
                            )
                          : Grid(tv: popular)),
                  _buildSectionTitle('On Air', () {
                    Navigator.of(context).push(_buildRoute(OnAirScreen()));
                  }),
                  Container(
                      height: constraints.maxHeight * SECTION_HEIGHT,
                      child: _isFetching
                          ? SpinKitCircle(
                              color: Theme.of(context).accentColor,
                              size: 21,
                            )
                          : Grid(tv: onAirToday)),
                  _buildSectionTitle('Top Rated', () {
                    Navigator.of(context).push(_buildRoute(TopRatedScreen()));
                  }),
                  Container(
                      height: constraints.maxHeight * SECTION_HEIGHT,
                      child: _isFetching
                          ? SpinKitCircle(
                              color: Theme.of(context).accentColor,
                              size: 21,
                            )
                          : Grid(tv: topRated)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class Grid extends StatelessWidget {
  final tv;
  Grid({this.tv});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey('Grid'),
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      itemCount: tv.length > 20 ? 20 : tv.length,
      itemBuilder: (context, index) {
        return tvWid.TVItem(
          item: tv[index],
          withFooter: true,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.8,
        // mainAxisSpacing: 5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}
