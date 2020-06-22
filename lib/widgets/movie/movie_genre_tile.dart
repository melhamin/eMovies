import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/movie_genre_item_screen.dart';
import 'package:flutter/material.dart';

class MovieGenreTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int genreId;

  MovieGenreTile({this.title, this.imageUrl, this.genreId});

  Route _buildRoute() {
    return MaterialPageRoute(
      builder: (context) => MovieGenreItem(genreId),      
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
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: FadeInImage(
                  image: AssetImage(imageUrl),
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: constraints.maxHeight * 0.4,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.9),
                          Color.fromRGBO(0, 0, 0, 0.05),
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
          onTap: () => _onTap(context),
        );
      },
    );
  }

}
