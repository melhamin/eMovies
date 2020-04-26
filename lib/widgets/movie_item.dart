import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/pages/details_page.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;

import 'package:e_movies/consts/consts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../pages/details_page.dart';

class MovieItem extends StatelessWidget {
  final movie;
  final bool withoutFooter;

  MovieItem({
    this.movie,
    this.withoutFooter = false,
  });

  Route _buildRoute(int id) {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: movie),
      pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(),
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

  String getGenreName(int genreId) {
    if (GENRES.containsKey(genreId)) {
      return GENRES[genreId];
    }
    return 'N/A';
  }

  void _navigate(BuildContext context, int id) {
    Navigator.of(context).push(_buildRoute(id));
  }

  String _formatDate(DateTime date) {
    if (date == null) return 'N/A';
    else {
      return intl.DateFormat.yMMM().format(date);
    }
    // return date == null ? 'Unk' : ;
  }

  Widget _buildBackgroundImage(
      BuildContext context, String title, String imageUrl) {
    return imageUrl == null
        ? PlaceHolderImage(title)
        // ? Image.asset('assets/images/poster_placeholder.png', fit: BoxFit.cover)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Center(
                child: SpinKitCircle(
                  color: Theme.of(context).accentColor,
                  size: LOADING_INDICATOR_SIZE,
                ),
              );
            },
          );
  }

  Widget _buildFooter(BuildContext context, double screenWidth, String title,
      int genreId, dynamic date) {
    return Positioned.directional(
      width: screenWidth / 2,
      height: 65,
      bottom: 0,
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                // Theme.of(context).accentColor.withOpacity(0.4),
                // Theme.of(context).accentColor.withOpacity(0.9),
                Color.fromRGBO(0, 0, 0, 1),
                Color.fromRGBO(0, 0, 0, 0.2),
              ]),
          // backgroundBlendMode: BlendMode.colorBurn,
        ),
        constraints: BoxConstraints(maxWidth: screenWidth / 2 - 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title == null ? 'Unk' : title,
                style: Theme.of(context).textTheme.headline5,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              // FittedBox(
              //   child: Text(
              //     getGenreName(genreId),
              //     style: Theme.of(context).textTheme.subtitle1,
              //     softWrap: false,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              // SizedBox(height: 5),
              FittedBox(
                child: Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.subtitle1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _navigate(context, movie.id),
      child: GridTile(
        child: Stack(
          children: <Widget>[
            _buildBackgroundImage(context, movie.title, movie.posterUrl),
            if (!withoutFooter)
              _buildFooter(
                context,
                screenWidth,
                movie.title,
                movie.genreIDs.isNotEmpty ? movie.genreIDs[0] : -1,
                movie.releaseDate,
              )
          ],
        ),
      ),
    );
  }
}
