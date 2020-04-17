import 'package:e_movies/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenresPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    MovieItem film;
    Provider.of<MoviesProvider>(context, listen: false).getMovieDetails(181812).then((value) {
      film = Provider.of<MoviesProvider>(context, listen: false).movieDetails;
    });    

    return Container(
      color: Colors.blue,
      // child: Center(child: Text(film.title),),
    );
  }
}