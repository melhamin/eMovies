import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/movies.dart';
import 'package:e_movies/genres.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = '/movie-detail-page';

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
            child: Flexible(
              flex: 1,
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
                      RatingBar(
                        initialRating: 5 * movie.voteAverage / 10,
                        maxRating: 10,
                        direction: Axis.horizontal,
                        itemSize: 15,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 5,
                        ),
                        onRatingUpdate: (double) {},
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
      children: <Widget>[
        Text(
          left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            right,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  String _getGenres(List<dynamic> genreIds) {
    String str = '';
    genreIds.forEach((id) {
      str += GENRES[id] + ', ';
    });
    str = str.substring(0, str.length - 2);
    return str;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final movie = Provider.of<Movies>(context).findById(id);
    final _height = MediaQuery.of(context).size.height;
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
                    Container(
                      child: Column(
                        children: <Widget>[
                          _buildDetailsItem(
                            'Genre:',
                            _getGenres(movie.genreIDs),
                          ),
                          _buildDetailsItem(
                            'Status:',
                            movie.status,
                          ),
                          _buildDetailsItem(
                            'Release Date:',
                            _formatDate(
                              movie.releaseDate,
                            ),
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
