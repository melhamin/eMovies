import 'package:e_movies/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';

import 'package:e_movies/widgets/loading_indicator.dart';
import '../providers/movies.dart';
import 'package:e_movies/genres.dart';
import '../widgets/movie_item.dart' as mo;

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail-page';

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isLoading;
  bool _isInitLoaded;
  bool _moreDetails;

  MovieItem _detailedMovie;
  List<MovieItem> _recommended;
  List<MovieItem> _similar;

  // ScrollPhysics scrollPhysics = ScrollPhysics(NeverScrollableScrollPhysics());

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isInitLoaded = true;
    _moreDetails = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final id = ModalRoute.of(context).settings.arguments as int;
      Provider.of<Movies>(context, listen: false).getMovieDetails(id).then(
            (_) => {
              setState(
                () {
                  _detailedMovie =
                      Provider.of<Movies>(context, listen: false).movieDetails;
                  _recommended =
                      Provider.of<Movies>(context, listen: false).recommended;
                  _similar =
                      Provider.of<Movies>(context, listen: false).similar;
                  // Future.delayed(Duration(seconds: 2)).then((value) => _isLoading = false );
                  _isLoading = false;
                },
              )
            },
          );
    }
    _isInitLoaded = false;
    super.didChangeDependencies();
  }

  // Widget loading(Animation<double> animation, double height, double width) {
  // return Container(
  //   height: height * 0.20,
  //   width: width * 0.8,
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Container(
  //         height: height * 0.009,
  //         width: width * 0.7,
  //         decoration: boxDecoration(animation),
  //       ),
  //       Container(
  //         height: height * 0.008,
  //         width: width * 0.5,
  //         decoration: boxDecoration(animation),
  //       ),
  //     ],
  //   ),
  // );
  // }

  Widget _buildTitleAndRatingBar(
      BuildContext context, MovieItem movie, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _isLoading
            ? LineLoadingIndicator(width: width * 0.6, singleLine: true)
            : Flexible(
                flex: 3,
                child: Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _isLoading
              ? LineLoadingIndicator(
                  width: width * 0.2,
                  singleLine: true,
                )
              : Container(
                  height: 31,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54)),
                        child: Center(
                          child: Text(
                            (5 * movie.voteAverage / 10).toStringAsFixed(1),
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RatingBar.readOnly(
                            initialRating: (5 * movie.voteAverage / 10),
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            isHalfAllowed: true,
                            halfFilledIcon: Icons.star_half,
                            size: 15,
                            filledColor: Colors.amber,
                            emptyColor: Colors.amberAccent,
                            maxRating: 5,
                          ),
                          Text(
                            movie.voteCount.toString() + ' votes',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, MovieItem movie, double _height, double _width) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0.4 * _height,
      leading: BackButton(),
      // centerTitle: true,
      stretch: true,
      flexibleSpace: _isLoading
          ? ImageLoadingIndicator(
              height: _height * 0.4,
              width: _width,
            )
          : FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.only(bottom: 0),
              stretchModes: [StretchMode.zoomBackground],
              title: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0.9),
                      ]),
                ),
                child: Center(
                  child: Text(
                    movie.title,
                    style: TextStyle(fontSize: 14),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              background: Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildDetailsItem(String left, String right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              child: Text(
                right,
                style: TextStyle(
                  color: Colors.white70,
                ),
                softWrap: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getGenres(List<dynamic> genreIds) {
    if (genreIds == null || genreIds.isEmpty) return 'N/A';
    String str = '';
    genreIds.forEach((elem) {
      // print('id: --------------- $id');
      str += GENRES[elem['id']] + ', ';
    });
    str = str.substring(0, str.lastIndexOf(','));
    return str;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MM yyyy').format(date);
  }

  String _getCast(List<dynamic> cast) {
    if (cast == null || cast.isEmpty) return 'N/A';
    String res = '';
    int length = cast.length > 10 ? 10 : cast.length;
    for (int i = 0; i < length; i++) {
      res += cast[i]['name'] + ', ';
    }
    res = res.substring(0, res.lastIndexOf(' '));
    res += '...';

    return res;
  }

  String _getCompanyOrCountry(List<dynamic> data) {
    if (data == null || data.isEmpty) return 'N/A';
    String res = '';
    data.forEach((element) {
      res += element['name'] + ', ';
    });
    res = res.substring(0, res.lastIndexOf(','));
    return res;
  }

  Widget _toggleDetails(bool more) {
    return Stack(
      children: <Widget>[
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0),
                Color.fromRGBO(0, 0, 0, 0.9),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(                        
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  more ? Text('More details') : Text('Less detail'),
                  more
                      ? Icon(Icons.expand_more, color: Colors.white70)
                      : Icon(Icons.expand_less, color: Colors.white70),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _moreDetails = !_moreDetails;
              });
            },
          ),
          // child: FlatButton(
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 8.0),
          //     child: Text(
          //       // more ? CupertinoIcons.ellipsis : CupertinoIcons.ellipsis,
          //       // color: Colors.white,
          //       more ? 'Show more...' : 'Show less...',
          //       style: TextStyle(color: Colors.white70),
          //     ),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _moreDetails = !_moreDetails;
          //     });
          //   },
          // ),
        ),
      ],
    );
  }

  Widget lessDetailed(MovieItem movie, double width) {
    return _isLoading
        ? LineLoadingIndicator(
            width: width * 0.4,
            singleLine: false,
          )
        : Column(
            children: <Widget>[
              _buildDetailsItem('Genre:', _getGenres(movie.genreIDs)),
              _buildDetailsItem('Status:', movie.status),
              Stack(
                children: <Widget>[
                  _buildDetailsItem(
                    'Release Date:',
                    _formatDate(movie.releaseDate),
                  ),
                  _toggleDetails(true),
                ],
              ),
            ],
          );
  }

  Widget detailed(MovieItem movie, MovieItem detailedMovie) {
    return Column(
      children: [
        _buildDetailsItem('Genre:', _getGenres(movie.genreIDs)),
        _buildDetailsItem('Status:', movie.status),
        _buildDetailsItem(
          'Release Date:',
          _formatDate(movie.releaseDate),
        ),
        _buildDetailsItem(
            'Duration:', detailedMovie.duration.toString() + ' min'),
        _buildDetailsItem('Actors:', _getCast(detailedMovie.cast)),
        _buildDetailsItem(
            'Budget:',
            (detailedMovie.budget == null || detailedMovie.budget <= 0)
                ? 'N/A'
                : detailedMovie.budget.toString() + '\$'),
        _buildDetailsItem('Reveue:', detailedMovie.revenue.toString() + '\$'),
        _buildDetailsItem('Popularity:', detailedMovie.popularity.toString()),
        _buildDetailsItem('Countries:',
            _getCompanyOrCountry(detailedMovie.productionContries)),
        Stack(
          children: <Widget>[
            _buildDetailsItem('Companies:',
                _getCompanyOrCountry(detailedMovie.productionCompanies)),
          ],
        ),
        _toggleDetails(false),
      ],
    );
  }

  Widget _extraMovies(
      List<MovieItem> similarMovies, double height, String title) {
    return Container(
      height: 0.3 * height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(title, style: Theme.of(context).textTheme.headline6),
          ),
          Flexible(
            child: GridView.builder(
              itemCount: _isLoading ? 5 : similarMovies.length,
              itemBuilder: (context, index) {
                return _isLoading
                    ? ImageLoadingIndicator(
                        height: height,
                        width: 30,
                      )
                    : mo.MovieItem(
                        movie: similarMovies[index],
                      );
              },
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(List<dynamic> reviews, double height) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 0.3 * height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.headline6,
          ),
          Divider(
            color: Colors.white70,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Author: ' + reviews[index]['author'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            (reviews[index]['context'] == null ||
                                    reviews[index]['context'].length == 0)
                                ? 'No content...'
                                : 'Content: ' +
                                    reviews[index]['content'].substring(
                                      0,
                                      reviews[index]['context'].length > 50
                                          ? 50
                                          : reviews[index]['context'].length,
                                    ),
                            style: TextStyle(color: Colors.white70)),
                        onTap: () {},
                      ),
                      Divider(
                        color: Colors.white70,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(double width) {
    return _isLoading
        ? LineLoadingIndicator(
            width: width,
            singleLine: false,
          )
        : Text(
            _detailedMovie.overview,
            style: Theme.of(context).textTheme.subtitle1,
          );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final transparentBackground = Container(
      color: TRRANSPARENT_BACKGROUND_COLOR,
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(children: <Widget>[
          Image.asset('assets/images/background_image_1.jpg'),
          transparentBackground,
          // _isLoading
          //   )
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [_buildSliverAppBar(context, _detailedMovie, _height, _width)],
            body: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
              child: ListView(
                children: [
                  _buildTitleAndRatingBar(context, _detailedMovie, _width),
                  SizedBox(height: 10),
                  _buildOverview(_width),
                  SizedBox(height: 10),
                  AnimatedContainer(
                    height: _moreDetails ? _height * 0.51 : _height * 0.13,
                    curve: Curves.easeInOutSine,
                    duration: Duration(milliseconds: 600),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: _moreDetails
                          ? detailed(_detailedMovie, _detailedMovie)
                          : lessDetailed(_detailedMovie, _width),
                    ),
                  ),
                  // SizedBox(height: 10),
                  _extraMovies(_recommended, _height, 'You May Also Like'),
                  if (!_isLoading)
                    _buildReviews(_detailedMovie.reviews, _height),
                  if (!_isLoading)
                    _extraMovies(_similar, _height, 'Similar Movies'),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
