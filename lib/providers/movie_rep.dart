import 'dart:async';
import 'package:e_movies/providers/movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:e_movies/providers/movie_list.dart';

class MovieRep with ChangeNotifier {

  static const API_KEY = '0ce2331b7a1f2dd735ece9351d3fa34c';
  static const IMAGE_WEIGHT = 'w500';
  static const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';
  static const API_BASE_URL = 'https://api.themoviedb.org/3/movie/upcoming?api_key=';

  List<MovieItem> _movies;

   Future<MovieList> fetchMovies(int page_number) async {
    final response = await http.get(API_BASE_URL + API_KEY + '&page=' + page_number.toString());
    final Map responseData = JsonCodec().decode(response.body);
    final movies = MovieList.fromMap(responseData);
    print('movies decoded: ------------------>' + response.body);
    if(movies == null) {
      throw Exception('Something went wrong...');      
    }

    // if(movies == null) {
    //   print('-------> movies is null');
    // } else {
    //   print('movie title ----> ' + movies.movies[0].title);
    // }
    print('-------> Movies fetched');
    // _movies = movies.movies;
    // notifyListeners();
    return movies;

  }

  MovieItem getMovie(int id) {
    return _movies.firstWhere((element) => element.id == id);
  }
}