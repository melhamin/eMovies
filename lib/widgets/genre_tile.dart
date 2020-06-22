import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/screens/tv/tv_genre_item_screen.dart';
import 'package:flutter/material.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/movie_genre_item_screen.dart';

class GenreTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int genreId;
  final MediaType mediaType;

  GenreTile({this.title, this.imageUrl, this.genreId, this.mediaType});

  Route _buildRoute() {
    return PageRouteBuilder(
      // settings: RouteSettings(arguments: genreId),
      pageBuilder: (context, animation,
              secondaryAnimation) => // navigates to corresponding screen according to media type parameter(0 for movies, 1 for tv show)
          mediaType == MediaType.Movie ? MovieGenreItem(genreId) : TVGenreItemScreen(genreId),
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

  void _onTap(BuildContext context) {
    Navigator.of(context).push(_buildRoute());
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                // color: Colors.red,
                child: FadeInImage(
                  // fadeInDuration: Duration(milliseconds: 200),
                  image: AssetImage(imageUrl),
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                // alignment: Alignment.bottomCenter,
                bottom: -2,
                child: Container(
                  height: constraints.maxHeight * 0.6,
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.05),                                                    
                        ]),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  title,
                  style: kTitleStyle2,
                ),
              ),
            ],
          ),
            ),
          ),
          onTap: () => _onTap(context),
        );
      },
    );
  }
}
