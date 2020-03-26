import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/movies.dart';

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
        child: Flexible(
          flex: 1,
          child: Row(
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
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
                  RatingBar(
                    initialRating: 5 * movie.voteAverage / 10,
                    maxRating: 10,
                    direction: Axis.horizontal,
                    // itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemSize: 15,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 5,
                    ),
                    // glowColor: Colors.amber,
                    // unratedColor: Colors.amber,
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
    ],
  );
}

Widget _buildSliverAppBar(
    BuildContext context, MovieItem movie, double _height) {
  return SliverAppBar(
    pinned: true,
    expandedHeight: 0.4 * _height,
    leading: BackButton(),
    centerTitle: true,
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

class MovieDetailPage extends StatelessWidget {
  static const routeName = '/movie-detail-page';
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
