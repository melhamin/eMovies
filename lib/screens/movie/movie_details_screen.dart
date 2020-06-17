import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/review_model.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/screens/search/all_actors_screen.dart';
import 'package:e_movies/screens/video_page.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/expandable_text.dart';
import 'package:e_movies/widgets/image_clipper.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/route_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:e_movies/widgets/movie/movie_item.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:e_movies/widgets/my_lists_item.dart';
import 'package:e_movies/widgets/review_item.dart';

import 'package:e_movies/my_toast_message.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/details-screen-movies';
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isInitLoaded = true;
  bool _isLoading = true;
  InitData initData;
  MovieModel film;

  TextEditingController _textEditingController;

  AnimationController _animationController;
  Animation<Offset> _animation;
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
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
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final initData = ModalRoute.of(context).settings.arguments as InitData;
      // print('movie----------> $initData');
      Provider.of<Movies>(context, listen: false)
          .getMovieDetails(initData.id)
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

  void _toggleFavorite(bool isInfavorites) {
    if (isInfavorites) {
      Provider.of<Lists>(context, listen: false)
          .removeFavoriteMovie(initData.id);

      // ToastUtils.removeOverlay();
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: _buildToastMessageIcons(
            Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 70),
            'Removed from Favorites'),
      );
    } else {
      Provider.of<Lists>(context, listen: false).addToFavoriteMovies(initData);
      // update top genre movies list
      Provider.of<Search>(context, listen: false).addToTopMovieGenres(initData);

      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: Colors.transparent,
        duration: Duration(seconds: TOAST_DURATION),
        child: _buildToastMessageIcons(
            Icon(Icons.favorite,
                color: Theme.of(context).accentColor, size: 80),
            ''),
      );
    }
  }

  Widget _buildBottomIcons() {
    final isInFavorites = Provider.of<Lists>(context).isFavoriteMovie(initData);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      decoration: BoxDecoration(
          color: ONE_LEVEL_ELEVATION,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Icon(
              isInFavorites ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () => _toggleFavorite(isInFavorites),
          ),
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () {
              _showAddToList(context, initData);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.share,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onTap: () {},
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

  Widget _buildImages(MovieModel film) {
    List<String> images = [];
    if (film.images != null) {
      film.images.forEach((element) {
        images.add(IMAGE_URL + element['file_path']);
      });
    }

    return film.images.length > 0
        ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
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
                  fit: BoxFit.cover,
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
              mainAxisSpacing: 10,
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

  Widget _buildDetails(MovieModel film) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
          top: BorderSide(color: LINE_COLOR, width: 0.5),
        ),
        color: ONE_LEVEL_ELEVATION,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.all(0),
            title: Text('Release Date', style: kSubtitle1),
            trailing: Text(
                film.date != null
                    ? DateFormat.yMMMd().format(film.date)
                    : 'N/A',
                style: kBodyStyle),
          ),
          Divider(
            indent: LEFT_PADDING,
            endIndent: LEFT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Runtime', style: kSubtitle1),
            trailing:
                Text(film.duration.toString() + ' min', style: kBodyStyle),
          ),
          Divider(
            indent: LEFT_PADDING,
            endIndent: LEFT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Rating', style: kSubtitle1),
            trailing: Text(
                film.voteAverage == 0 ? 'NR' : film.voteAverage.toString(),
                style: kBodyStyle),
          ),
          Divider(
            indent: LEFT_PADDING,
            endIndent: LEFT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Genres', style: kSubtitle1),
            trailing: Text(_getGenres(film.genreIDs), style: kBodyStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMovies(BoxConstraints constraints) {
    List<MovieModel> similar = [];
    if (film.similar != null) {
      film.similar.forEach((element) {
        similar.add(MovieModel.fromJson(element));
      });
    }
    if (similar.isEmpty) {
      return Container();
    } else {
      return Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarMovies(similar),
      );
    }
  }

  Route _buildRoute(Widget toPage, [dynamic args]) {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: args),
      pageBuilder: (context, animation, secondaryAnimation) => toPage,
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

  List<Widget> _buildCast() {
    List<CastModel> cast = [];    
    if (film.cast != null) {
      film.cast.forEach((element) {
        cast.add(CastModel(
          id: element['id'],
          name: element['name'],
          character: element['character'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }
    return [
      Padding(
        padding: const EdgeInsets.only(
            left: LEFT_PADDING, bottom: 5, right: LEFT_PADDING),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Cast', style: kSubtitle1),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(_buildRoute(CastDetailsScreen(cast)));
              },
              child: Row(
                children: [
                  Text('Details', style: kSeeAll),
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
      ),
      Container(
        color: ONE_LEVEL_ELEVATION,
        height: 110,
        child: Cast(cast: cast),
      ),
    ];
  }

  List<Widget> _buildReviews() {
    List<ReviewModel> reviews = [];
    if(film.reviews != null) {
      film.reviews.forEach((element) { 
        reviews.add(ReviewModel.fromJson(element));
      });
    }
    return [
      if(reviews.isNotEmpty)
      Padding(
        padding: EdgeInsets.only(left: LEFT_PADDING, bottom: 5, top: 30),
        child: Text('Reviews', style: kSubtitle1),
      ),      
      Reviews(reviews),
    ];
  }

  // Builds parts that needs detailed film to be fetched
  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('DetailsPage ---------------------> ${film.videos}');
    return [
      if (film.images != null && film.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.20, child: _buildImages(film)),
      SizedBox(height: 20),
      _buildDetails(film),
      SizedBox(height: 30),
      ..._buildCast(),
      SizedBox(height: 30),
      _buildSimilarMovies(constraints),      
      ..._buildReviews(),      
      SizedBox(height: 10),
    ];
  }

  Widget _buildDialogButtons(String title, Function onTap,
      [bool leftButton = false]) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: ONE_LEVEL_ELEVATION,
            // border: Border(right: BorderSide(color: kTextBorderColor, width: 0.5)),
            borderRadius: BorderRadius.only(
              bottomLeft: leftButton
                  ? Radius.circular(20)
                  : Radius.circular(0), // add border radius to left
              bottomRight: leftButton
                  ? Radius.circular(0)
                  : Radius.circular(20), // and right accordingly
            )),
        height: 40,
        child: leftButton // only add right border to the left button
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: kTextBorderColor, width: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: FlatButton(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Helvatica',
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: onTap,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: FlatButton(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Helvatica',
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onTap,
                ),
              ),
      ),
    );
  }

  void _addList(BuildContext context) {
    if (_textEditingController.text.isEmpty) return;
    // print('tex---------> ${_textEditingController.text}');
    final result = Provider.of<Lists>(context, listen: false)
        .addNewMovieList(_textEditingController.text);
    // Set _isEmpty to true and clear the textfield

    if (result) {
      // update top movie genres list
      Provider.of<Search>(context, listen: false).addToTopMovieGenres(initData);
      Navigator.of(context).pop();
      _textEditingController.clear();
    } else {
      ToastUtils.myToastMessage(
        context: context,
        alignment: Alignment.center,
        color: BASELINE_COLOR_TRANSPARENT,
        duration: Duration(seconds: TOAST_DURATION),
        child: _buildToastMessageIcons(
            Icon(Icons.warning,
                color: Colors.white.withOpacity(0.87), size: 50),
            'List Already Exist'),
      );
    }
  }

  void _showAddNewListDialog(BuildContext context) {
    // _textEditingController.text = '${initData.title}';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ONE_LEVEL_ELEVATION,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Create New List', style: kTitleStyle),
              Text('Give a name for this new list', style: kBodyStyle),
            ],
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: 120,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: kTextBorderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  child: TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: 'Name',
                        hintStyle: kSubtitle1,
                        border: InputBorder.none,
                      ),
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(
                        color: Hexcolor('#DEDEDE'),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvatica',
                      ),
                      autofocus: true,
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (val) => _addList(context)),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: kTextBorderColor, width: 0.5))),
                // padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDialogButtons('Cancel', () {
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    }, true),
                    _buildDialogButtons('Create', () => _addList(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToastMessageIcons(Icon icon, String message,
      [double iconSize = 50]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 15),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.87),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void _addNewItemtoList(BuildContext context, int index, InitData item) {
    final result = Provider.of<Lists>(context, listen: false)
        .addNewMovieToList(index, item);
    if (result) {
      Navigator.of(context).pop();
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.done, color: Colors.white.withOpacity(0.87), size: 50),
              'Item added.'));
    } else {
      ToastUtils.myToastMessage(
          context: context,
          alignment: Alignment.center,
          color: BASELINE_COLOR_TRANSPARENT,
          duration: Duration(seconds: TOAST_DURATION),
          child: _buildToastMessageIcons(
              Icon(Icons.warning,
                  color: Colors.white.withOpacity(0.87), size: 50),
              'Item is already in the list.'));
    }
  }

  void _showAddToList(BuildContext context, InitData initData) {
    final lists = Provider.of<Lists>(context, listen: false).moviesLists;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(),
        decoration: BoxDecoration(
          // color: Colors.black,
          color: BASELINE_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: ListView(
          children: <Widget>[
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: ONE_LEVEL_ELEVATION,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.cen,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 82,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Helvatica',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text('Add to List', style: kTitleStyle),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(top: 20, right: LEFT_PADDING),
                itemCount:
                    lists.length + 1, // since first element is New List button
                itemBuilder: (context, i) {
                  return i == 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).accentColor,
                              ),
                              child: FlatButton(
                                child: Text('New List', style: kTitleStyle),
                                onPressed: () => _showAddNewListDialog(context),
                              ),
                            ),
                          ),
                        )
                      : MyListsItem(
                          list: lists[i - 1],
                          onTap: () =>
                              _addNewItemtoList(context, i - 1, initData));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: 21,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initData = ModalRoute.of(context).settings.arguments as InitData;
    // print('initData------------> $initData');
    // if(!_isLoading)
    // print('details -----------> ${film.genreIDs}');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (ctx, constraints) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  // padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
                  children: [
                    BackgroundAndTitle(
                      initData: initData,
                      film: film,
                      constraints: constraints,
                      isLoading: _isLoading,
                    ),
                    // if (!_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                        left: LEFT_PADDING,
                        right: LEFT_PADDING,
                      ),
                      child: Text('Storyline', style: kTitleStyle2),
                    ),
                    _isLoading
                        ? Container(
                            height: constraints.maxHeight * 0.3 - 2,
                            child: _buildLoadingIndicator(context),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 10,
                              horizontal: LEFT_PADDING,
                            ),
                            child: Overview(
                                initData: film, constraints: constraints),
                          ),
                    // if (!_isLoading)
                    Container(
                      height: constraints.maxHeight * 0.1,
                      child: _buildBottomIcons(),
                    ),
                    SizedBox(height: 20),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, initData.id)
                    else
                      Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  50), // so the loading indicator is at overview place
                          child: _showLoadingIndicator()),
                  ],
                );
              },
            ),
            // TopBar(title: 'title'),
            Positioned(
              top: 10,
              left: 10,
              child: CustomBackButton(),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class BackgroundAndTitle extends StatefulWidget {
  const BackgroundAndTitle({
    Key key,
    @required this.initData,
    @required this.film,
    @required this.constraints,
    @required this.isLoading,
  }) : super(key: key);

  final InitData initData;
  final MovieModel film;
  final BoxConstraints constraints;
  final bool isLoading;

  @override
  _BackgroundAndTitleState createState() => _BackgroundAndTitleState();
}

class _BackgroundAndTitleState extends State<BackgroundAndTitle>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // background image animation controller
  AnimationController _animationController;
  var _backgroundImageScale = 0.0;
  bool initLoaded = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 200),
      )
        ..addListener(() {
          setState(() {
            // update image scale as animation controller value changes
            _backgroundImageScale = _animationController.value;
          });
        })
        ..forward();
    });

    initLoaded = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGenre() {
    // print('genreIDs-----------> ${widget.initData['genreIDs']}');
    return widget.initData.genreIDs == null
        ? 'N/A'
        : MOVIE_GENRES[widget.initData.genreIDs[0]] ?? 'N/A';
  }

  String _getRating() {
    return widget.initData.voteAverage == null
        ? 'N/A'
        : widget.initData.voteAverage == 0
            ? 'NR'
            : widget.initData.voteAverage.toString();
  }

  String _getYearAndDuration() {
    String str = '';
    if (widget.film.date == null) {
      str += 'N/A';
    } else {
      str += widget.film.date.year.toString();
    }
    if (widget.film.duration != null) {
      str = str + ' \u2022 ' + widget.film.duration.toString() + ' min';
    }
    return str;
  }

  Route _buildRoute(Widget toPage) {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: [widget.film.id, MediaType.Movie]),
      pageBuilder: (context, animation, secondaryAnimation) => toPage,
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

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        size: 21,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Container(
          // color: BASELINE_COLOR,
          padding: const EdgeInsets.only(bottom: 80),
          height: widget.constraints.maxHeight * 0.55,
          child: Stack(
            children: [
              ClipPath(
                clipper: ImageClipper(),
                child:
                    // widget.isLoading
                    //     ? _buildLoadingIndicator(context)
                    //     :
                    Transform.scale(
                  scale: _backgroundImageScale,
                  child: widget.initData.backdropUrl == null
                      ? PlaceHolderImage(widget.initData.backdropUrl ?? 'N/A')
                      : CachedNetworkImage(
                          imageUrl: widget.initData.backdropUrl,
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
              ),
              // Container(

              //   margin: const EdgeInsets.only(bottom: 80),
              //   color: Colors.black38,
              // ),

              // Build shadow on background image
              ClipPath(
                clipper: ImageClipper(),
                child: Container(
                  color: Colors.black45,
                ),
              ),
              Positioned(
                // to the center of background image
                top: widget.constraints.maxHeight * 0.275 - 100,
                // right: MediaQuery.of(context).size.width / 2,
                right: widget.constraints.maxWidth / 2 - 40,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_buildRoute(VideoPage()));
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: widget.constraints.maxHeight * 0.55 -
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
                  child: Card(
                    color: BASELINE_COLOR,
                    shadowColor: Colors.white12,
                    elevation: 5,
                    child: widget.initData.posterUrl == null
                        ? PlaceHolderImage(widget.initData.title ?? 'N/A')
                        : CachedNetworkImage(
                            imageUrl: widget.initData.posterUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return Center(
                                child: SpinKitCircle(
                                  color: Theme.of(context).accentColor,
                                  size: LOADING_INDICATOR_SIZE,
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: LEFT_PADDING,
                        top:
                            70), // part of the poster image that overlaps background image
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.initData.title ?? 'N/A',
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
                        SizedBox(height: 10),
                        if (!widget.isLoading)
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

  @override
  bool get wantKeepAlive => true;
}

class Overview extends StatefulWidget {
  const Overview({
    Key key,
    @required this.initData,
    @required this.constraints,
  }) : super(key: key);

  final MovieModel initData;
  final BoxConstraints constraints;

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with AutomaticKeepAliveClientMixin {
  bool _expanded = false;

  void onTap() => setState(() => _expanded = true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RegExp pattern = new RegExp(r'\n', caseSensitive: false);
    final overview = widget.initData.overview.replaceAll(pattern, '');
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      constraints: _expanded
          ? BoxConstraints(
              maxHeight: 400,
              minHeight: widget.constraints.maxHeight * 0.3 - 2,
            )
          : BoxConstraints(
              minHeight: widget.constraints.maxHeight * 0.3 - 2,
              maxHeight: widget.constraints.maxHeight * 0.3 - 2,
            ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          child: ExpandableText(
            overview,
            style: kBodyStyle,
            onTap: onTap,
            trimExpandedText: '',
            trimCollapsedText: '...More',
            trimLines: 7,
          ),
        ),
      ),
    );
    //  ConstrainedBox(
    //   constraints: _expanded
    //       ? BoxConstraints(
    //           minHeight: widget.constraints.maxHeight *
    //               0.30 - 2, // otherwise bottom icons will move up if text length is small
    //         )
    //       : BoxConstraints(
    //           maxHeight: widget.constraints.maxHeight * 0.30 - 2,
    //         ),
    //   child: AnimatedSize(
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeIn,
    //     vsync: this,
    //     child: _expanded
    //         ? Padding(
    //             padding: const EdgeInsets.only(bottom: 5),
    //             child: Text(
    //               widget.initData.overview,
    //               // initData.overview,
    //               style: kBodyStyle,
    //               // softWrap: true,

    //               // maxLines: _expanded ? 2 ^ 64 : null,
    //               // overflow: TextOverflow.ellipsis,
    //             ),
    //           )
    //         : SizedBox.expand(
    //             child: Container(
    //               child: GestureDetector(
    //                 onTap: widget.initData.overview.length > 200
    //                     ? () {
    //                         setState(() {
    //                           _expanded = !_expanded;
    //                         });
    //                       }
    //                     : null,
    //                 child: RichText(
    //                   text: TextSpan(
    //                       text: widget.initData.overview.length < 200
    //                           ? widget.initData.overview
    //                           : widget.initData.overview.substring(0, 200) +
    //                               '...',
    //                       style: kBodyStyle,
    //                       children: [
    //                         if (!_expanded &&
    //                             widget.initData.overview.length > 200)
    //                           TextSpan(
    //                               text: 'More',
    //                               style: TextStyle(
    //                                 color: Theme.of(context).accentColor,
    //                               ))
    //                       ]),
    //                 ),
    //               ),
    //             ),
    //           ),
    //   ),
    // );
  }

  @override
  bool get wantKeepAlive => true;
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

class Cast extends StatelessWidget {
  final List<CastModel> cast;
  Cast({this.cast});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: cast.length,
      itemBuilder: (ctx, i) {
        return CastItem(
          cast[i],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        // mainAxisSpacing: 5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}

class SimilarMovies extends StatelessWidget {
  final List<MovieModel> similar;
  SimilarMovies(this.similar);
  @override
  Widget build(BuildContext context) {
    return Column(
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
            itemCount: similar.length,
            itemBuilder: (context, index) {
              return MovieItem(
                item: similar[index],
                withoutDetails: true,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class Reviews extends StatelessWidget {
  final List<ReviewModel> reviews;
  Reviews(this.reviews);
  @override
  Widget build(BuildContext context) {
    // final reviews = Provider.of<Movies>(context).reviews;
    return ListView.separated(
      separatorBuilder: (_, i) => SizedBox(height: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (_, i) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
          color: ONE_LEVEL_ELEVATION,
          child: ReviewItem(
            item: reviews[i],
          ),
        );
      },
    );
  }
}
