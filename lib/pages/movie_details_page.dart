import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';

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

  @override
  void initState() {
    _isLoading = true;
    _isInitLoaded = true;
    _moreDetails = false;
    super.initState();
    // Future.delayed(Duration(seconds: 3)).then((_) {
    //   final args =
    //       ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    //   type = args['type'];
    //   id = args['id'];
    // });
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      // setState(() {
      //   _isLoading = true;
      // });
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final id = args['id'];
      print('id mov ***---------------> $id');
      Provider.of<Movies>(context, listen: false)
          .getMovieDetails(id)
          .then((_) => {
                setState(() {
                  _detailedMovie =
                      Provider.of<Movies>(context, listen: false).movieDetails;
                  _recommended =
                      Provider.of<Movies>(context, listen: false).recommended;
                  _similar =
                      Provider.of<Movies>(context, listen: false).similar;
                  _isLoading = false;
                })
              });
    }
    _isInitLoaded = false;
    super.didChangeDependencies();
  }

  Widget _buildTitleAndRatingBar(BuildContext context, MovieItem movie) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            movie.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 31,
            child: Row(
              children: <Widget>[
                Container(
                  height: 30,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white54)),
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
                    // RatingBar(
                    //   initialRating: 5 * movie.voteAverage / 10,
                    //   maxRating: 10,
                    //   direction: Axis.horizontal,
                    //   itemSize: 15,
                    //   itemBuilder: (context, index) => Icon(
                    //     Icons.star,
                    //     color: Colors.amber,
                    //     size: 5,
                    //   ),
                    //   onRatingUpdate: (double) {},
                    // ),
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
      BuildContext context, MovieItem movie, double _height) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0.4 * _height,
      leading: BackButton(),
      // centerTitle: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
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
    genreIds.forEach((id) {
      str += GENRES[id] + ', ';
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
    for (int i = 0; i < 10; i++) {
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
          height: 25,
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
        Center(
          child: FlatButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                // more ? CupertinoIcons.ellipsis : CupertinoIcons.ellipsis,
                // color: Colors.white,
                more ? 'Show more...' : 'Show less...',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            onPressed: () {
              setState(() {
                _moreDetails = !_moreDetails;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget lessDetailed(MovieItem movie) {
    return Column(
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
      children: <Widget>[
        _buildDetailsItem('Genre:', _getGenres(movie.genreIDs)),
        _buildDetailsItem('Status:', movie.status),
        _buildDetailsItem(
          'Release Date:',
          _formatDate(movie.releaseDate),
        ),
        _buildDetailsItem(
            'Duration:', detailedMovie.duration.toString() + ' min'),
        _buildDetailsItem('Actors:', _getCast(detailedMovie.cast)),
        _buildDetailsItem('Budget:', detailedMovie.budget.toString()),
        _buildDetailsItem('Reveue:', detailedMovie.revenue.toString()),
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

  Widget _similarMovies(List<MovieItem> similarMovies, String type) {
    return GridView.builder(
        itemCount: similarMovies.length,
        itemBuilder: (context, index) {
    return mo.MovieItem(
      movie: similarMovies[index],
      type: type,
    );        
        },
        scrollDirection: Axis.horizontal,      
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1, 
    childAspectRatio: 1,
    crossAxisSpacing: 5, 
    mainAxisSpacing: 5,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    print('_isLoading --------------> $_isLoading');
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final type = args['type'];
    final id = args['id'];
    final movie = type == 'upcoming'
        ? Provider.of<Movies>(context, listen: false).findByIdUpcoming(id)
        : Provider.of<Movies>(context, listen: false).findByIdTrending(id);
    final _height = MediaQuery.of(context).size.height;
    if (!_isLoading)
      print('recommended -----------------> ${_recommended[0].title}');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Image.asset('assets/images/background_image.jpg'),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  [_buildSliverAppBar(context, movie, _height)],
              body: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleAndRatingBar(context, movie),
                    SizedBox(height: 10),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          !_moreDetails
                              ? lessDetailed(movie)
                              : detailed(movie, _detailedMovie),
                              if(_isLoading)
                              Center(child: CircularProgressIndicator()),
                              if(!_isLoading)
                              Container(
                                height: 150,
                                child: _similarMovies(_similar, type),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.favorite_border,
          ),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
