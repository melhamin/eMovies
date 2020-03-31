import 'package:flutter/cupertino.dart';

import 'movies.dart';

class MovieList with ChangeNotifier{

  // final List<MovieItem> movies;
  final int page;
  final int total_results;
  final int total_pages;

  MovieList({
    // this.movies,
    this.page,
    this.total_pages,
    this.total_results,
  });

  MovieList.fromMap(Map<String, dynamic> data)
  : page = data['page'],
  total_pages = data['total_pages'],
  total_results = data['total_results'];
  // movies = List<MovieItem>.from(data['results'].map((movie) => MovieItem.fromJson(movie)));  

  

}