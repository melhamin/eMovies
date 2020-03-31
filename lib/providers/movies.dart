import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieItem {

  final int id;
  final String title;
  final String imageUrl;
  final String overview;
  final DateTime releaseDate;
  final List<dynamic> genreIDs;
  final String originalLanguage;
  final String status;
  final double voteAverage;
  final int voteCount;
  final String mediaType;
  final double popularity;

  MovieItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.genreIDs,
    @required this.overview,
    @required this.releaseDate,
    @required this.originalLanguage,
    @required this.status,
    @required this.mediaType,
    @required this.voteAverage,
    @required this.voteCount,
    @required this.popularity,
  });

  static const IMAGE_WEIGHT = 'w500';
  static const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';

  static MovieItem fromJson(dynamic element) {
    return MovieItem(
        id: element['id'],
        title: element['title'],
        genreIDs: element['genre_ids'],
        imageUrl: '$IMAGE_URL/${element['poster_path']}',
        overview: element['overview'],
        releaseDate: element['release_date'] == null
            ? DateTime.parse('0000-00-00')
            : DateTime.tryParse(element['release_date']),
        originalLanguage: element['original_language'],
        status: element['release_date'] == null ? 'Not Released': 'Released',
        mediaType: element['media_type'],
        // voteAverage: element['vote_average'],
        voteAverage: 9.3,
        voteCount: element['vote_count'],
        // popularity: element['popularity'].toDouble(),
        popularity: 9.3
      );
  }

  @override
  String toString() {
    return 'id: $id\n title:$title\n imageUrl: $imageUrl\n overview: $overview\n vote_average: $voteAverage\n release_date: $releaseDate\n';
  }
}

class Movies with ChangeNotifier {
  static const API_KEY = '0ce2331b7a1f2dd735ece9351d3fa34c';  
  static const BASE_URL = 'https://api.themoviedb.org/3/movie';

  List<MovieItem> _upcomingMovies = []; 
  List<MovieItem> _trendingMovies = []; 

  List<MovieItem> get upcomingMovies {
    return [..._upcomingMovies];
  }

  List<MovieItem> get trendingMovies {
    return [..._trendingMovies];
  }  

  Future<void> fetchTrendingMovies() async {
    //https://api.themoviedb.org/3/trending/all/day?api_key=0ce2331b7a1f2dd735ece9351d3fa34c
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url = 'https://api.themoviedb.org/3/trending/all/day?api_key=$API_KEY';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _trendingMovies.add(MovieItem.fromJson(element));
    });
    print('length movies(trending) -------------> ' + trendingMoviesLength().toString());
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies(int page) async {
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url = '$BASE_URL/upcoming?api_key=$API_KEY&language=en-US&page=$page';
    final response = await http.get(url);
    print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _upcomingMovies.add(MovieItem.fromJson(element));
    });
    print('length movies(upcoming) -------------> ' + upcomingMoviesLength().toString());
    notifyListeners();
  }

  int upcomingMoviesLength() {
    return _upcomingMovies.length;
  }

  int trendingMoviesLength() {
    return _trendingMovies.length;
  }

  MovieItem findByIdUpcoming(int id) {
    return _upcomingMovies.firstWhere((element) => element.id == id);
  }

}
