import 'dart:convert';

import 'package:e_movies/providers/cast.dart';
import 'package:http/http.dart' as http;
import 'package:e_movies/providers/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Search with ChangeNotifier {

  List<MovieItem> _movies = [];
  List<CastItem> _people = [];

  List<MovieItem> get movies {
    return _movies;
  }

  void clearMovies() => _movies.clear();

  Future<void> searchMovies(String query, int page) async {
    final url = 'https://api.themoviedb.org/3/search/movie?api_key=${DotEnv().env['API_KEY']}&language=en-US&query=$query&page=$page&include_adult=false';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];

      if(page == 1) _movies.clear();

      data.forEach((element) {
        _movies.add(MovieItem.fromJson(element));
      });

      print(_movies);
    } catch (error) {
      print('searchMovies error  --------------------> $error');
      throw error;
    }
  }
  
}