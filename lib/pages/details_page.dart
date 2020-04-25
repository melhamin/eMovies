import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/pages/video_page.dart';
import 'package:e_movies/providers/cast_provider.dart';
import 'package:e_movies/widgets/details_item.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:e_movies/widgets/movie_item.dart' as wid;
import 'package:e_movies/providers/movies_provider.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/cast_item.dart' as wid;

class DetailsPage extends StatefulWidget {
  static const routeName = '/details-page';
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  bool _isInitLoaded = true;
  bool _isFetching = true;
  MovieItem film;
  List<CastItem> cast = [];
  List<CastItem> crew = [];

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
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final id = ModalRoute.of(context).settings.arguments as int;
      Provider.of<MoviesProvider>(context, listen: false)
          .getMovieDetails(id)
          .then((value) {
        setState(() {
          _isFetching = false;
          _isInitLoaded = false;
          // Get film item
          film =
              Provider.of<MoviesProvider>(context, listen: false).movieDetails;

          // get Crew data
          film.crew.forEach((element) {
            // print('name ---------> ${element['character']} ');
            // if (element['job'] == 'Director') {
            //   print('Director --------------> ${element['name']} ');
            // }
            crew.add(CastItem(
              id: element['id'],
              name: element['name'],
              imageUrl: element['profile_path'],
              job: element['job'],
            ));
          });
          // Get cast data
          film.cast.forEach((element) {
            // print('name/ ---------> ${element['character']} ');
            cast.add(CastItem(
              id: element['id'],
              name: element['name'],
              imageUrl: element['profile_path'],
              character: element['character'],
            ));
          });
        });
      });
    }
    
    super.didChangeDependencies();
  }

  Widget _buildBottomIcons() {
    return Container(
      color: BASELINE_COLOR,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            onPressed: () {},
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

  Widget _buildRatings(double voteAverage) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: PADDING),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: LINE_COLOR),
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
        ),
      ),
      child: SlideTransition(
        position: _animation,
        child: GridView(
          children: [
            RatingItem(title: 'My Rating', subtitle: '9.3'),
            RatingItem(title: 'TMDB Rating', subtitle: voteAverage.toString()),
            // RatingItem(title: 'TMDB Rating', subtitle: '9.5'),
            // RatingItem(title: 'TMDB Rating', subtitle: '9.5'),
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 3,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  /**
   * Build page route for image view
   */
  Route _buildRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ImageView(),
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
            padding: EdgeInsets.symmetric(horizontal: PADDING),
            // controller: _scrollController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_buildRoute());
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

  // Widget _buildSectionTitle(String title) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: PADDING),
  //         child: Text(title, style: Theme.of(context).textTheme.subtitle1),
  //       ),
  //       // Divider(color: LINE_COLOR),
  //     ],
  //   );
  // }

  Widget _buildOverview(String overview) {
    return overview == null
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildSectionTitle('Overview'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: PADDING, right: 10, top: 5),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: LINE_COLOR, width: 0.5),
                  ),
                  color: BASELINE_COLOR,
                ),
                child: (overview == null || overview.length == 0)
                    ? Text(
                        'Overview not available',
                        style: Theme.of(context).textTheme.headline3,
                      )
                    : ExpandText(
                        overview,
                        maxLength: 3,
                        style: Theme.of(context).textTheme.headline3,
                        arrowColor: Theme.of(context).accentColor,
                      ),
              ),
            ],
          );
  }

  String _getGenres(List<dynamic> ids) {
    if (ids == null || ids.length == 0) return 'N/A';
    int length = ids.length < 3 ? ids.length : 3;
    String res = '';
    for (int i = 0; i < length; i++) {
      res = res + GENRES[ids[i]['id']] + ', ';
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
            right: DateFormat.yMMMd().format(film.releaseDate),
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
    bool hasItem = (Provider.of<MoviesProvider>(context).similar != null &&
        Provider.of<MoviesProvider>(context).similar.length > 0);
    if (!hasItem) {
      return Container();
    } else {
      return Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarMovies(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DetailsPage ---------------------> build()');
    return SafeArea(
      child: Scaffold(
        body: _isFetching
            ? Center(child: _showLoadingIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      ListView(
                        physics: BouncingScrollPhysics(),
                        // padding: EdgeInsets.symmetric(vertical: APP_BAR_HEIGHT),
                        addAutomaticKeepAlives: true,
                        // cacheExtent: 20,
                        children: [
                          Container(
                            height: constraints.maxHeight * 0.9,
                            child: InitialView(film: film),
                          ),
                          Container(
                            color: Colors.black,
                            height: constraints.maxHeight * 0.1,
                            child: _buildBottomIcons(),
                          ),
                          Container(
                            height: constraints.maxHeight * 0.1,
                            child: _buildRatings(film.voteAverage),
                          ),
                          if (film.images != null && film.images.length > 0)
                            Container(
                                height: constraints.maxHeight * 0.2,
                                child: _buildImages(film)),
                          _buildOverview(film.overview),
                          SizedBox(height: 30),
                          _buildDetails(film),
                          SizedBox(height: 30),
                          Cast(cast: cast, crew: crew),
                          // SizedBox(height: 30),
                          _buildSimilarMovies(constraints),
                        ],
                      ),
                      TopBar(film.title),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class InitialView extends StatelessWidget {
  final MovieItem film;

  InitialView({this.film});
  @override
  Widget build(BuildContext context) {
    String _getDateAndDuration() {
      String res = '';
      if (film.releaseDate != null) {
        res = res + film.releaseDate.year.toString() + ' | ';
      } else {
        res = res + 'Unk' + ' | ';
      }

      if (film.duration != null) {
        res += film.duration.toString() + ' min';
      } else {
        res += 'Unk';
      }

      return res;
    }

    Widget _buildFooter() {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: constraints.maxHeight * 0.15,
                  color: BASELINE_COLOR,
                  // color: Colors.black54,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: (constraints.maxWidth * 0.3),
                        top: 10,
                      ),
                      child: Container(
                        width: constraints.maxWidth * 0.6,
                        child: Text(
                          film.title,
                          softWrap: true,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ),
              Positioned(
                bottom: constraints.maxHeight * 0.03,
                // left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_circle_outline),
                      iconSize: 80,
                      color: Colors.amber,
                      onPressed: () {
                        Navigator.of(context).pushNamed(VideoPage.routeName);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: PADDING),
                      width: constraints.maxWidth * 0.4,
                      child: Text(_getDateAndDuration(),
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    Widget _buildBackgroundImage(MovieItem film) {
      return film.imageUrl == null
          ? PlaceHolderImage(film.title)
          // ? Image.asset('assets/images/poster_placeholder.png',
          // fit: BoxFit.cover)
          : CachedNetworkImage(
              imageUrl: film.imageUrl,
              fadeInCurve: Curves.fastOutSlowIn,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  // color: const Color(0xff000000),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
            );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  height: constraints.maxHeight - 1,
                  child: _buildBackgroundImage(film),
                ),
                // TODO *** find the source of the padding ****
                // Without this container there would be a tiny padding between
                // footer and bottom of the background image
                Container(
                  height: 1,
                  color: BASELINE_COLOR,
                ),
              ],
            ),
            _buildFooter(),
          ],
        );
      },
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
  final List<CastItem> crew;
  final List<CastItem> cast;
  Cast({this.crew, this.cast});
  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> with AutomaticKeepAliveClientMixin {
  bool _expanded = false;

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
    print('Cast ------------------------> initState()');
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

  // Calculate number of items in different situations
  int _calcualteItemCount() {
    return widget.cast.length > 5
        ? (_expanded ? (widget.cast.length > 10 ? 10 : widget.cast.length) : 5)
        : widget.cast.length;

    /**
     * More clear implemention of above statement
     */
    // if (widget.cast.length > 5) {
    //   if (_expanded) {
    //     if (widget.cast.length > 10) {
    //       return 10;
    //     } else {
    //       return widget.cast.length;
    //     }
    //   } else
    //     return 5;
    // }
    // return widget.cast.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('Cast ----------------------> build()');
    CastItem director = widget.crew.firstWhere((element) {
      return element.job == 'Director';
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (director != null)
            Padding(
              padding: const EdgeInsets.only(left: PADDING, bottom: 5),
              child: Text('Director',
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: LINE_COLOR),
                top: BorderSide(width: 0.5, color: LINE_COLOR),
              ),
              color: BASELINE_COLOR,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: director.imageUrl == null
                    ? Theme.of(context).accentColor
                    : Colors.black,
                backgroundImage: director.imageUrl != null
                    ? NetworkImage(IMAGE_URL + director.imageUrl)
                    : null,
                child: director.imageUrl != null
                    ? null
                    : Text(
                        _getName(director.name),
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
              ),
              title: Text(
                director.name,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
          if (widget.cast != null && widget.cast.length > 0)
            SizedBox(height: 20),
          if (widget.cast != null && widget.cast.length > 0)
            Padding(
              padding: const EdgeInsets.only(left: PADDING, bottom: 5),
              child: Text('Cast', style: Theme.of(context).textTheme.subtitle1),
            ),
          if (widget.cast != null && widget.cast.length > 0)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _calcualteItemCount() * 60.0, // ListTile height
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: LINE_COLOR),
                  top: BorderSide(width: 0.5, color: LINE_COLOR),
                ),
                color: BASELINE_COLOR,
              ),
              child: ListView.builder(
                // addAutomaticKeepAlives: true,
                // shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _calcualteItemCount(),
                itemBuilder: (context, index) {
                  CastItem item = widget.cast[index];
                  return wid.CastItem(
                    item: item,
                    // to add border to all except last one
                    last: _isLasItem(index),
                  );
                },
              ),
            ),
          if ((widget.cast.length > 5))
            ListTile(
              leading: Text(
                (!_expanded) ? 'Show More...' : '',
                style: TextStyle(color: Colors.amber),
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

class SimilarMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<MoviesProvider>(context, listen: false).similar;
    return (movies == null || movies.length == 0)
        ? Container()
        : LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: PADDING),
                      child: Text('Similar Movies',
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    SizedBox(height: 5),
                    Flexible(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: PADDING),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return wid.MovieItem(
                            movie: movies[index],
                            withoutFooter: true,
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 5,
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

/**
 * Padding(
              padding: const EdgeInsets.only(left: PADDING, bottom: 5),
              child: Text('Director',
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: LINE_COLOR),
                top: BorderSide(width: 0.5, color: LINE_COLOR),
              ),
              color: BASELINE_COLOR,
            ),
 */
