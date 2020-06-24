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
    return MaterialPageRoute(
      builder: (context) =>mediaType == MediaType.Movie ? MovieGenreItem(genreId) : TVGenreItemScreen(genreId),      
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
                          Colors.black.withOpacity(0.8),
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
