import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/providers/cast.dart' as castProv;
import 'package:e_movies/providers/tv.dart';
import 'package:e_movies/screens/movie/movie_genre_item_screen.dart';
import 'package:e_movies/screens/movie/trending_movies_screen.dart';
import 'package:e_movies/screens/tv/on_air_screen.dart';
import 'package:e_movies/screens/tv/popular_screen.dart';
import 'package:e_movies/screens/tv/top_rated_screen.dart';
import 'package:e_movies/screens/tv/tv_genre_item_screen.dart';
import 'package:e_movies/widgets/movie/in_theaters.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/screens/movie/top_rated_screen.dart';
import 'package:e_movies/screens/movie/upcoming_screen.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/movie_item.dart' as movieWid;
import 'package:e_movies/widgets/tv/tv_item.dart' as tvWid;
import 'package:e_movies/widgets/movie/cast_item.dart' as castWid;

class DiscoverScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool _initLoaded = true;
  bool _isFetching = true;
  TabController _tabController;

  static const SECTION_HEIGHT = 0.35;

  bool showTitle = false;

  ScrollController _scrollController;
  // double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      // Fetch movies
      Provider.of<Movies>(context, listen: false).fetchTrending(1);
      Provider.of<Movies>(context, listen: false).fetchUpcoming(1);
      Provider.of<Movies>(context, listen: false).fetchForKids(1);
      Provider.of<castProv.Cast>(context, listen: false).getPopularPeople(1);
      Provider.of<Movies>(context, listen: false)
          .fetchTopRated(1)
          .then((value) {
        setState(() {
          _isFetching = false;
        });
      });
      // Fetch TV shows
      Provider.of<TV>(context, listen: false).fetchPopular(1);
      Provider.of<TV>(context, listen: false).fetchOnAirToday(1);
      Provider.of<TV>(context, listen: false).fetchTopRated(1);
      Provider.of<TV>(context, listen: false).fetchForKids(1);
    }
    _initLoaded = false;
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
          Text(title,
              style: TextStyle(
                fontFamily: 'Helvatica',
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.87),
              )),
          if (withSeeAll)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('See All', style: kSeeAll)),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Route _buildRoute(Widget child) {
    return MaterialPageRoute(
      builder: (context) => child,
      
    );   
  }

  Widget _buildPopularActors(List<CastModel> popularPeople) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      physics: const BouncingScrollPhysics(),
      itemCount: popularPeople.length > 20 ? 20 : popularPeople.length,
      itemBuilder: (ctx, i) {
        // print('length ++++++++++++++++++ ${popularPeople.length}');
        return castWid.CastItem(
         popularPeople[i],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white
    ));
    // Movies
    final trending = Provider.of<Movies>(context).trending;
    final upcoming = Provider.of<Movies>(context).upcoming;
    final topRated = Provider.of<Movies>(context).topRated;
    final forKids = Provider.of<Movies>(context).forKids;
    final popularPeople = Provider.of<castProv.Cast>(context).popularPeople;

    // Tv
    final tvPopular = Provider.of<TV>(context, listen: false).trending;
    final tvOnAirToday = Provider.of<TV>(context, listen: false).onAirToday;
    final tvTopRated = Provider.of<TV>(context, listen: false).topRated;
    final forKidsTV = Provider.of<TV>(context, listen: false).forKids;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
                  child: LayoutBuilder(
            builder: (ctx, constraints) {
              //  height of each section
              double sectionHeight = constraints.maxHeight * SECTION_HEIGHT;
              double inTheatersGridHeight = constraints.maxHeight * 0.3;
              double popularPeopleHeight = constraints.maxHeight * 0.15;
              double forKidsHeight = constraints.maxHeight * 0.2;
              return Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(bottom: kToolbarHeight, top: 20),
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                        child: Text('Discover',
                            style: TextStyle(
                              fontFamily: 'Helvatica',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.87),
                            )),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: inTheatersGridHeight,
                        child: InTheatersGrid(),
                      ),
                      _buildSectionTitle('Trending', () {
                        Navigator.of(context)
                            .push(_buildRoute(TrendingMoviesScreen()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: trending,
                                  storageKey: 'Movie-Trending',
                                )),
                      _buildSectionTitle('Coming Soon', () {
                        Navigator.of(context).push(_buildRoute(UpcomingScreen()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: upcoming,
                                  storageKey: 'Movie-Upcoming',
                                )),

                      _buildSectionTitle('For Kids', () {
                        Navigator.of(context)
                            .push(_buildRoute(MovieGenreItem(16)));
                      }),
                      Container(
                          height: forKidsHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: forKids,
                                  storageKey: 'Movie-For_Kids',
                                  isRound: true,
                                )),
                      _buildSectionTitle('Top Rated', () {
                        Navigator.of(context).push(_buildRoute(TopRated()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: topRated,
                                  storageKey: 'Movie-Top_Rated',
                                )),

                      _buildSectionTitle('Popular Actors', () {
                        Navigator.of(context)
                            .push(_buildRoute(MovieGenreItem(16)));
                      }),
                      Container(
                          height: popularPeopleHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : _buildPopularActors(popularPeople)),

                      // TV shows
                      _buildSectionTitle('Popular', () {
                        Navigator.of(context)
                            .push(_buildRoute(TrendingTVScreen()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: tvPopular,
                                  storageKey: 'TV-Popular',
                                )),
                      _buildSectionTitle('On Air Today', () {
                        Navigator.of(context).push(_buildRoute(OnAirScreen()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: tvOnAirToday,
                                  storageKey: 'TV-On-Air-Today',
                                )),
                      _buildSectionTitle('For Kids', () {
                        Navigator.of(context)
                            .push(_buildRoute(TVGenreItemScreen(10762)));
                      }),
                      Container(
                          height: constraints.maxHeight * 0.2,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: forKidsTV,
                                  storageKey: 'TV-For_Kids',
                                  isRound: true,
                                )),
                      _buildSectionTitle('Top Rated', () {
                        Navigator.of(context).push(_buildRoute(TopRatedScreen()));
                      }),
                      Container(
                          height: sectionHeight,
                          child: _isFetching
                              ? SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 21,
                                )
                              : Grid(
                                  items: tvTopRated,
                                  storageKey: 'TV-Top-Rated',
                                )),
                      // Text(_scrollController.position.pixels.toString(), style: kTitleStyle2,)
                    ],
                  ),
                  DynamicTopBar(
                      scrollController: _scrollController,
                      constraints: constraints)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DynamicTopBar extends StatelessWidget {
  const DynamicTopBar({
    Key key,
    @required ScrollController scrollController,
    @required BoxConstraints constraints,
  })  : _scrollController = scrollController,
        constraints = constraints,
        super(key: key);

  final ScrollController _scrollController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    double sectionHeight = constraints.maxHeight * 0.35;
    return Positioned(
      child: StatefulBuilder(
        builder: (ctx, thisState) {
          _scrollController.addListener(() {
            thisState(() {});
          });
          String getTitle() {
            if (_scrollController.position.pixels <
                (3 * (sectionHeight + 40) +
                    constraints.maxHeight * 0.3 + // in Thaters grid height
                    constraints.maxHeight * 0.15 + // Popular Actors section height
                    constraints.maxHeight * 0.2) + // forKids height
                    160 
                    ) // Height of 'Discover', each section, padding, and SizedBoxs used
              return 'Movies';
            else
              return 'TV Shows';
          }

          return _scrollController.position.pixels <= 40
              ? Container()
              : Container(
                  height: 50,
                  color: BASELINE_COLOR,
                  child: Center(
                    child: Text(
                      getTitle(),
                      style: kTitleStyle,
                    ),
                  ),
                );
          //  TopBar(title: getTitle());
        },
      ),
    );
  }
}

class Grid extends StatelessWidget {
  final items;
  final String storageKey;
  final bool isRound;
  Grid({this.items, this.storageKey, this.isRound = false});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey(storageKey),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
          left: LEFT_PADDING, right: 5), // fix mainAxisSpacing error
      itemCount: items.length > 20 ? 20 : items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
            // Padding set because error is thrown when mainAxisSpacing is set
            padding: const EdgeInsets.only(right: 10),
            child: movieWid.MovieItem(
              item: item,
              isRound: isRound,
            ) 
            );
      },
      addAutomaticKeepAlives: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: isRound ? 2 / 3 : 1.5,
        //TODO fix (The "maxPaintExtent" is less than the "paintExtent".) when mainAxisSpacing set
        // mainAxisSpacing: 10,
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
