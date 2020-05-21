import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/pages/video_page.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/movie/details_item.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/route_builder.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:e_movies/widgets/movie/movie_item.dart' as wid;
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/cast_item.dart' as castWid;

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/details-screen-movies';
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsScreen>
    with TickerProviderStateMixin {
  bool _isInitLoaded = true;
  bool _isLoading = true;
  MovieItem initData;
  MovieItem film;

  bool _expanded = false;

  AnimationController _animationController;
  Animation<Offset> _animation;
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();
    _animation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    //   _scrollController = ScrollController(
    //   initialScrollOffset: -1,

    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final movie = ModalRoute.of(context).settings.arguments as MovieItem;
      Provider.of<Movies>(context, listen: false)
          .getMovieDetails(movie.id)
          .then((value) {
        setState(() {
          // Get film item
          film = Provider.of<Movies>(context, listen: false).movieDetails;
          _isLoading = false;
          _isInitLoaded = false;
        });
      });
    }

    super.didChangeDependencies();
  }

  Widget _buildBottomIcons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: BASELINE_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {
              _showAddToList(context, initData);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _showLoadingIndicator() {
    return SpinKitCircle(
      size: LOADING_INDICATOR_SIZE,
      color: Theme.of(context).accentColor,
    );
  }

  // Widget _buildRatings(double voteAverage) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 10, left: LEFT_PADDING),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         top: BorderSide(width: 0.5, color: LINE_COLOR),
  //         bottom: BorderSide(width: 0.5, color: LINE_COLOR),
  //       ),
  //     ),
  //     child: SlideTransition(
  //       position: _animation,
  //       child: GridView(
  //         children: [
  //           RatingItem(title: 'My Rating', subtitle: '9.3'),
  //           RatingItem(title: 'TMDB Rating', subtitle: voteAverage.toString()),
  //           // RatingItem(title: 'TMDB Rating', subtitle: '9.5'),
  //           // RatingItem(title: 'TMDB Rating', subtitle: '9.5'),
  //         ],
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 1,
  //           childAspectRatio: 1 / 3,
  //         ),
  //         scrollDirection: Axis.horizontal,
  //       ),
  //     ),
  //   );
  // }

  /**
   * Build page route for image view
   */
  // Route _buildRoute(Widget toPage) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => toPage,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(
  //           1, 0); // if x > 0 and y = 0 transition is from right to left
  //       var end =
  //           Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
  //       var tween = Tween(begin: begin, end: end);
  //       var offsetAnimation = animation.drive(tween);

  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  Widget _buildImages(MovieItem film) {
    List<String> images = [];
    if (film.images != null) {
      film.images.forEach((element) {
        images.add(IMAGE_URL + element['file_path']);
      });
    }

    return film.images.length > 0
        ? GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
            // controller: _scrollController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(BuildRoute.buildRoute(toPage: ImageView(images)));
                },
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fadeInCurve: Curves.fastOutSlowIn,
                  placeholder: (context, url) {
                    return Center(
                      child: SpinKitCircle(
                        size: LOADING_INDICATOR_SIZE,
                        color: Theme.of(context).accentColor,
                      ),
                    );
                  },
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2 / 3,
              mainAxisSpacing: 3,
            ),
            scrollDirection: Axis.horizontal,
          )
        : null;
  }

  String _getGenres(List<dynamic> ids) {
    if (ids == null || ids.length == 0) return 'N/A';
    int length = ids.length < 3 ? ids.length : 3;
    String res = '';
    for (int i = 0; i < length; i++) {
      res = res + MOVIE_GENRES[ids[i]['id']] + ', ';
    }
    res = res.substring(0, res.lastIndexOf(','));
    return res;
  }

  Widget _buildDetails(MovieItem film) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
          top: BorderSide(color: LINE_COLOR, width: 0.5),
        ),
        color: BASELINE_COLOR,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          DetailsItem(
            left: 'Release Date',
            right: film.releaseDate != null
                ? DateFormat.yMMMd().format(film.releaseDate)
                : 'N/A',
          ),
          DetailsItem(
            left: 'Runtime',
            right: film.duration.toString() + ' min',
          ),
          DetailsItem(
            left: 'Rating',
            right: film.voteAverage.toString(),
          ),
          DetailsItem(
            left: 'Genres',
            right: _getGenres(film.genreIDs),
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMovies(BoxConstraints constraints) {
    bool hasItem = (Provider.of<Movies>(context).similar != null &&
        Provider.of<Movies>(context).similar.length > 0);
    if (!hasItem) {
      return Container();
    } else {
      return Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarMovies(),
      );
    }
  }

  // Builds parts that needs detailed film to be fetched
  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('DetailsPage ---------------------> ${film.videos}');
    return [
      if (film.images != null && film.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.2, child: _buildImages(film)),
      SizedBox(height: 30),
      _buildDetails(film),
      SizedBox(height: 30),
      Cast(details: film),
      // SizedBox(height: 30),
      _buildSimilarMovies(constraints),
      // Container(
      //   height: constraints.maxHeight * 0.3,
      //   child: SimilarMovies(id),
      // ),
      SizedBox(height: 5),
    ];
  }

  void _showAddToList(BuildContext context, MovieItem item) {
    final lists = Provider.of<Lists>(context, listen: false).moviesLists;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: ListView(
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 82,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.back,
                            color: Theme.of(context).accentColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Cancel',
                              style: kBTStyle,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Text('Add To', style: kTitleStyle),
                  IconButton(
                    // iconSize: 10,
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Theme.of(context).accentColor,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.separated(
                separatorBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      thickness: 0.5,
                      color: kTextBorderColor,
                    ),
                  );
                },
                itemCount: lists.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      Provider.of<Lists>(context, listen: false)
                          .addNewItem(i, initData);
                      Navigator.of(context).pop();
                    },
                    dense: true,
                    title: Text(
                      lists[i]['title'],
                      style: kBodyStyle,
                    ),
                    trailing: Text(
                      '${lists[i]['data'].length}',
                      style: kSubtitle1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    // showBottomSheet(
    //   context: context,
    //   builder: (context) => ListView.separated(
    //     separatorBuilder: (context, i) {
    //       return Divider(
    //         thickness: 0.5,
    //         color: kTextBorderColor,
    //       );
    //     },
    //     itemCount: lists.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         title: Text(
    //           lists[i]['title'],
    //           style: kBodyStyle,
    //         ),
    //         trailing: Text(
    //           lists[i]['data'].length,
    //           style: kSubtitle1,
    //         ),
    //       );
    //     },
    //   ),
    // );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Add To'),
    //     content: ListView.separated(
    //       separatorBuilder: (context, i) {
    //         return Divider(
    //           thickness: 0.5,
    //           color: kTextBorderColor,
    //         );
    //       },
    //       itemCount: lists.length,
    //       itemBuilder: (context, i) {
    //         return ListTile(
    //           title: Text(
    //             lists[i]['title'],
    //             style: kBodyStyle,
    //           ),
    //           trailing: Text(
    //             lists[i]['data'].length,
    //             style: kSubtitle1,
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    initData = ModalRoute.of(context).settings.arguments as MovieItem;
    // print('DetailsPage ------------------------> build() id: ${initData.id}');
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
                  children: [
                    BackgroundAndTitle(
                      initData: initData,
                      film: film,
                      constraints: constraints,
                      isLoading: _isLoading,
                    ),
                    if (!_isLoading)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          left: LEFT_PADDING,
                          right: LEFT_PADDING,
                        ),
                        child: Text('Storyline', style: kTitleStyle),
                      ),
                    if (!_isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          // vertical: 10,
                          horizontal: LEFT_PADDING,
                        ),
                        child: Overview(
                            initData: initData, constraints: constraints),
                      ),
                    if (!_isLoading)
                      Container(
                        color: Colors.black,
                        height: constraints.maxHeight * 0.1,
                        child: _buildBottomIcons(),
                      ),
                    SizedBox(height: 10),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, initData.id)
                    else
                      Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  50), // so the loading indicator is at overview place
                          child: _showLoadingIndicator()),
                  ],
                ),
                TopBar(title: initData.title),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BackgroundAndTitle extends StatelessWidget {
  const BackgroundAndTitle({
    Key key,
    @required this.initData,
    @required this.film,
    @required this.constraints,
    @required this.isLoading,
  }) : super(key: key);

  final MovieItem initData;
  final MovieItem film;
  final BoxConstraints constraints;
  final bool isLoading;

  String _getGenre() {
    return (initData.genreIDs == null || initData.genreIDs.length == 0)
        ? 'N/A'
        : MOVIE_GENRES[initData.genreIDs[0]];
  }

  String _getRating() {
    return initData.voteAverage == null
        ? 'N/A'
        : initData.voteAverage.toString();
  }

  String _getYearAndDuration() {
    String str = '';
    if (film.releaseDate == null) {
      str += 'N/A';
    } else {
      str += film.releaseDate.year.toString();
    }
    if (film.duration != null) {
      str = str + ' \u2022 ' + film.duration.toString() + ' min';
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    // print('film ---------> ${film.genreIDs}');
    // print('initData -------> ${initData.genreIDs}');

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 80),
          height: constraints.maxHeight * 0.55,
          child: Stack(
            children: [
              ClipPath(
                clipper: ImageClipper(),
                child: initData.backdropUrl == null
                    ? PlaceHolderImage(film.title)
                    : CachedNetworkImage(
                        imageUrl: initData.backdropUrl,
                        fadeInCurve: Curves.easeIn,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: imageProvider,
                            ),
                          ),
                        ),
                      ),
              ),
              Container(
                color: Colors.black26,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              //     child: Container(
              //       decoration: new BoxDecoration(
              //           color: Colors.grey.shade200.withOpacity(0)),
              //     ),
              //   ),
              // ),
              Positioned(
                top: constraints.maxHeight * 0.2 - APP_BAR_HEIGHT,
                // right: MediaQuery.of(context).size.width / 2,
                right: constraints.maxWidth / 2 - 40,

                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          settings: RouteSettings(arguments: film.id),
                          builder: (context) {
                            return VideoPage();
                          },
                        ));
                      },
                      // child: Image.asset('assets/icons/play.gif'),
                      child: SvgPicture.asset(
                        'assets/icons/play.svg',
                        color: Theme.of(context).accentColor,
                        height: 80,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'Trailer',
                          style: kBodyStyle,
                        ),
                      ),
                    ),
                    // OutlineButton(
                    //   borderSide: BorderSide(color: Colors.white, width: 2),
                    //   onPressed: () {},
                    //   child: Text('Trailer', style: kSubtitle1,),
                    // ),
                  ],
                ),
                // child: Icon(
                //   Icons.play_circle_outline,
                //   color: Hexcolor('#DEDEDE'),
                //   size: 100,
                // ),
              ),
            ],
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.55 -
              180, // (180 calculated from small poster height and padding given to the background image so the overlaps the background image)
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: LEFT_PADDING -
                        5, // TODO find source of the padding at the left
                    right: LEFT_PADDING,
                  ),
                  width: 130,
                  height: 180,
                  child: wid.MovieItem(
                    movie: initData,
                    withFooter: false,
                    tappable: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: LEFT_PADDING,
                        top:
                            75), // part of the poster image that overlaps background image
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AutoSizeText(
                        //   initData.title,
                        //   style: kTitleStyle,
                        // ),
                        Text(
                          initData.title,
                          style: kTitleStyle2,
                          softWrap: true,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: kTextBorderColor, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1),
                                child: Text(
                                  // 'Action',
                                  _getGenre(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white54),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              _getRating(),
                              style: kSubtitle1,
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.favorite_border,
                                color: Theme.of(context).accentColor),
                          ],
                        ),
                        if (!isLoading)
                          SizedBox(height: 10),
                        if (!isLoading)
                          Text(
                            _getYearAndDuration(),
                            style: kSubtitle1,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Overview extends StatefulWidget {
  const Overview({
    Key key,
    @required this.initData,
    @required this.constraints,
  }) : super(key: key);

  final MovieItem initData;
  final BoxConstraints constraints;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _expanded
          ? BoxConstraints(
              minHeight: widget.constraints.maxHeight * 0.30 - APP_BAR_HEIGHT,
            )
          : BoxConstraints(
              maxHeight:
                  widget.constraints.maxHeight * 0.30 - APP_BAR_HEIGHT - 5,
            ),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        vsync: this,
        child: _expanded
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.initData.overview,
                  // initData.overview,
                  style: kBodyStyle,
                  // softWrap: true,

                  // maxLines: _expanded ? 2 ^ 64 : null,
                  // overflow: TextOverflow.ellipsis,
                ),
              )
            : SizedBox.expand(
                child: GestureDetector(
                  onTap: widget.initData.overview.length > 200
                      ? () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        }
                      : null,
                  child: RichText(
                    text: TextSpan(
                        text: widget.initData.overview.length < 200
                            ? widget.initData.overview
                            : widget.initData.overview.substring(0, 200) +
                                '...',
                        style: kBodyStyle,
                        children: [
                          if (!_expanded &&
                              widget.initData.overview.length > 200)
                            TextSpan(
                                text: 'More',
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ))
                        ]),
                  ),
                ),
              ),
      ),
    );
  }
}

class RatingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  RatingItem({this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(title, style: Theme.of(context).textTheme.subtitle1),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(subtitle, style: Theme.of(context).textTheme.headline3),
        )
      ],
    );
  }
}

class Cast extends StatefulWidget {
  final MovieItem details;
  Cast({this.details});
  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> with AutomaticKeepAliveClientMixin {
  bool _expanded = false;

  List<CastItem> crew = [];
  List<CastItem> cast = [];

  // Get the name abbreviation for circle avatar in case image is not available
  String _getName(String str) {
    String res = '';
    List<String> name = str.split(' ');
    res = res + name[0][0].toUpperCase() + name[1][0].toUpperCase();
    return res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get Crew data
    if (widget.details.crew != null) {
      widget.details.crew.forEach((element) {
        crew.add(CastItem(
          id: element['id'],
          name: element['name'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }
    // Get cast data
    if (widget.details.cast != null) {
      widget.details.cast.forEach((element) {
        // print('name/ ---------> ${element['character']} ');
        cast.add(CastItem(
          id: element['id'],
          name: element['name'],
          imageUrl: element['profile_path'],
          character: element['character'],
        ));
      });
    }
    // print('Cast ------------------------> initState()');
  }

  void _onTap() {
    setState(() {
      _expanded = true;
    });
  }

  // finds whether at index (index) is the last item
  // and draw bottom border accroding to it
  bool _isLasItem(int index) {
    return (!_expanded
        ? (index == 4 ? true : false)
        : (index == _calcualteItemCount() - 1 ? true : false));
  }

  // Calculate number of items depending on whether list is expanded or not
  int _calcualteItemCount() {
    return cast.length > 5
        ? (_expanded ? (cast.length > 10 ? 10 : cast.length) : 5)
        : cast.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('Cast ----------------------> build()');
    CastItem director = crew.firstWhere((element) {
      return element.job == 'Director';
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (director != null)
            Padding(
              padding: const EdgeInsets.only(left: LEFT_PADDING, bottom: 5),
              child: Text('Director', style: kSubtitle1),
            ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: LINE_COLOR),
                top: BorderSide(width: 0.5, color: LINE_COLOR),
              ),
              color: BASELINE_COLOR,
            ),
            child: castWid.CastItem(
              item: director,
              last: false,
              subtitle: false,
            ),
          ),
          if (cast != null && cast.length > 0) SizedBox(height: 20),
          if (cast != null && cast.length > 0)
            Padding(
              padding: const EdgeInsets.only(left: LEFT_PADDING, bottom: 5),
              child: Text('Cast', style: kSubtitle1),
            ),
          if (cast != null && cast.length > 0)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _calcualteItemCount() * 60.0 + _calcualteItemCount() * 5,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: LINE_COLOR),
                  top: BorderSide(width: 0.5, color: LINE_COLOR),
                ),
                color: BASELINE_COLOR,
              ),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _calcualteItemCount(),
                itemBuilder: (context, index) {
                  CastItem item = cast[index];
                  return castWid.CastItem(
                    item: item,
                    // add border to all except last one
                    last: _isLasItem(index),
                  );
                },
              ),
            ),
          if ((cast.length > 5))
            ListTile(
              leading: Text(
                (!_expanded) ? 'More...' : '',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onTap: !_expanded ? _onTap : null,
            ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// class SimilarMovies extends StatefulWidget {
//   final id;
//   SimilarMovies(this.id);
//   @override
//   _SimilarMoviesState createState() => _SimilarMoviesState();
// }

// class _SimilarMoviesState extends State<SimilarMovies> {
//   bool _initLoaded = true;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if(_initLoaded) {
//       Provider.of<Movies>(context, listen: false).getSimilar(widget.id).then((value) {
//         // print('similar movies ------------------------');
//         setState(() {
//           _isLoading = false;
//           _initLoaded = false;
//         });
//       });
//     }
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }

//   Widget _buildLoadingIndicator(BuildContext context) {
//     return Center(
//       child: SpinKitCircle(
//         size: 21,
//         color: Theme.of(context).accentColor,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = Provider.of<Movies>(context, listen: false).similar;
//     print('Movie simialr size ----------------------> ${items.length}');
//     return _isLoading ? _buildLoadingIndicator(context) :
//     (items.length == 0)
//         ? Container()
//         : LayoutBuilder(
//             builder: (context, constraints) {
//               return Container(
//                 height: constraints.maxHeight * 0.5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: LEFT_PADDING),
//                       child: Text('Similar', style: kSubtitle1),
//                     ),
//                     SizedBox(height: 5),
//                     Flexible(
//                       child: GridView.builder(
//                         physics: BouncingScrollPhysics(),
//                         padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           return wid.MovieItem(
//                             movie: items[index],
//                             withFooter: false,
//                             tappable: true,
//                           );
//                         },
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 1,
//                           childAspectRatio: 3 / 2,
//                           // mainAxisSpacing: 5,
//                         ),
//                         scrollDirection: Axis.horizontal,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//   }
// }

class SimilarMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<Movies>(context, listen: false).similar;
    return (movies.length == 0)
        ? Container()
        : LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: LEFT_PADDING),
                      child: Text('Similar Movies', style: kSubtitle1),
                    ),
                    SizedBox(height: 5),
                    Flexible(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return wid.MovieItem(
                            movie: movies[index],
                            withFooter: false,
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 2,
                          // mainAxisSpacing: 5,
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {}

//   @override
//   bool shouldReclip(CustomClipper oldClipper) {
//     return false;
//   }
// }
