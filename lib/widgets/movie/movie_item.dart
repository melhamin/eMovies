import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/screens/movie/movie_details/movie_details_screen.dart';
import 'package:e_movies/screens/tv/tv_details_screen.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/placeholder_image.dart';

class MovieItem extends StatelessWidget {
  final item;
  final bool withoutDetails;
  final bool isRound;
  final double radius;
  final double elevation;

  MovieItem({
    this.item,
    this.withoutDetails = false,
    this.isRound = false,
    this.radius,
    this.elevation,
  });

  String getGenreName() {
    return (item.genreIDs == null || item.genreIDs.length == 0)
        ? 'N/A'
        : MOVIE_GENRES[item.genreIDs[0]];
  }

  String _getRatings(double rating) {
    return rating == null ? 'N/A' : rating.toString();
  }

  String _formatDate(DateTime date) {
    return date == null ? 'N/A' : date.year.toString();
  }

  Route _buildRoute() {
    final initData = InitData.formObject(item);
    return MaterialPageRoute(
      builder: (context) => item is MovieModel ? MovieDetailsScreen() : TVDetailsScreen(),
      settings: RouteSettings(arguments: initData),
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
          child: ClipRRect(
            borderRadius: isRound
                ? BorderRadius.circular(radius ?? 20)
                : BorderRadius.circular(0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                item.posterUrl == null
                    ? PlaceHolderImage(item.title)
                    : CachedNetworkImage(
                        imageUrl: item.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Center(
                            child: LoadingIndicator(),
                          );
                        },
                      ),
                if (!withoutDetails)
                  Positioned.fill(
                    bottom: -2,
                    child: Container(
                      height: constraints.maxHeight * 0.45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.01),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                if (!withoutDetails)
                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.only(right: 2, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Helvatica',
                              fontSize: 16,                              
                              color: Colors.white.withOpacity(0.87),
                            ),
                          ),                         
                          Container(
                            width: constraints.maxWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                FittedBox(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: Colors.white38)),
                                    child: Text(
                                      getGenreName() ?? 'N/A',
                                      style: kSubtitle1,
                                    ),
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
          ),
        );
      },
    );
  }
}
