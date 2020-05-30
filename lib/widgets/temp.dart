import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies.dart' as prov;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../pages/movie/movie_details_screen.dart';
import 'placeholder_image.dart';

class MovieItem extends StatelessWidget {
  final prov.MovieItem item;

  MovieItem({
    this.item,
  });

  String getGenreName() {
    return MOVIE_GENRES[item.genreIDs[0]];
  }

  String _getRatings(double rating) {
    return rating == null ? 'N/A' : rating.toString();
  }

  String _formatDate(DateTime date) {
    return date == null ? 'N/A' : date.year.toString();
  }

  Route _buildRoute() {
    final initData = {
      'id': item.id,
      'title': item.title,
      'genre': (item.genreIDs.length == 0 || item.genreIDs[0] == null)
          ? 'N/A'
          : item.genreIDs[0],
      'posterUrl': item.posterUrl,
      'backdropUrl': item.backdropUrl,
      'mediaType': item.mediaType,
      'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
      'voteAverage': item.voteAverage,
    };
    return PageRouteBuilder(
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        // var curve = Curves.bounceIn;
        var tween =
            Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {    
    return LayoutBuilder(
      builder: (context, constraints) {        
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(_buildRoute());
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              item.posterUrl == null
                  ? PlaceHolderImage(item.title)
                  : CachedNetworkImage(
                      imageUrl: item.posterUrl,
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 0, 0, 0.8),
                    Color.fromRGBO(0, 0, 0, 0.1),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 5,
                child: Container(
                  width: constraints.maxWidth,   
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Helvatica',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.87),
                        ),
                      ),
                      Text(
                        _formatDate(item.releaseDate),
                        style: kSubtitle1,
                      ),
                      Container(
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white38)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 2),
                                child: Text(
                                  getGenreName(),
                                  style: kSubtitle1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    _getRatings(item.voteAverage),
                                    style: kSubtitle1,
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.favorite_border,
                                      color: Theme.of(context).accentColor),
                                ],
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
        );
      },
    );
  }
}
