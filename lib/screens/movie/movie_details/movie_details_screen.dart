import 'dart:ui';

import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/background_and_title.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/bottom_icons/bottom_icons.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/movie_cast.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/details.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/movie_images.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/reviews.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/similar_movies.dart';
import 'package:e_movies/screens/movie/movie_details/widgets/overview.dart';
import 'package:e_movies/widgets/back_button.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:e_movies/widgets/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';

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
    Future.delayed(Duration.zero).then((value) {
      initData = ModalRoute.of(context).settings.arguments as InitData;
    });
  }

  @override
  void dispose() {
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

  Widget _buildSimilarMovies(BoxConstraints constraints) {
    if (film.similar.isEmpty) {
      return Container();
    } else {
      return Container(
        height: constraints.maxHeight * 0.3,
        child: SimilarMovies(film),
      );
    }
  }

  List<Widget> _buildReviews() {
    if (film.reviews.isNotEmpty)
      return [
        SectionTitle(title: 'Reviews', withSeeAll: false, bottomPadding: 5),
        Reviews(film),
      ];
    return [Container(height: 0, width: 0)];
  }

  // Builds parts that needs detailed film to be fetched
  List<Widget> _buildOtherDetails(BoxConstraints constraints, int id) {
    // print('DetailsPage ---------------------> ${film.videos}');
    return [
      if (film.images != null && film.images.length > 0)
        Container(
            height: constraints.maxHeight * 0.20,
            child: MovieImages(movie: film)),
      SizedBox(height: 20),
      Details(movie: film),
      SizedBox(height: 30),
      MovieCast(movie: film),
      SizedBox(height: 30),
      _buildSimilarMovies(constraints),
      ..._buildReviews(),
      SizedBox(height: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initData = ModalRoute.of(context).settings.arguments as InitData;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (ctx, constraints) {
                return ListView(
                  children: [
                    BackgroundAndTitle(
                      initData: initData,
                      film: film,
                      constraints: constraints,
                      isLoading: _isLoading,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                        left: DEFAULT_PADDING,
                        right: DEFAULT_PADDING,
                      ),
                      child: Text('Storyline', style: kTitleStyle3),
                    ),
                    _isLoading
                        ? Container(
                            height: constraints.maxHeight * 0.3,
                            child: LoadingIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 10,
                              horizontal: DEFAULT_PADDING,
                            ),
                            child: Overview(
                                initData: film, constraints: constraints),
                          ),
                    if (initData != null)
                      Container(
                        height: constraints.maxHeight * 0.1,
                        child: BottomIcons(initData: initData),
                      ),
                    SizedBox(height: 20),
                    if (!_isLoading)
                      ..._buildOtherDetails(constraints, initData.id)
                    else
                      Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  50), // so the loading indicator is at overview place
                          child: LoadingIndicator()),
                  ],
                );
              },
            ),
            // TopBar(title: 'title'),
            Positioned(
              top: 10,
              left: 0,
              child: CustomBackButton(),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
