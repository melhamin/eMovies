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

  int duration;
  int budget;
  String homepage;
  double popularity;
  int revenue;
  List<dynamic> reviews;
  List<dynamic> productionCompanies;
  List<dynamic> productionContries;
  List<dynamic> cast;
  List<dynamic> recommendations;
  List<dynamic> similar;

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

    this.duration,
    this.budget,
    this.homepage,
    this.revenue,
    this.cast,    
    this.productionCompanies,
    this.productionContries,
    this.recommendations,
    this.similar,
    this.popularity,
    this.reviews,
  });

  static const IMAGE_WEIGHT = 'w500';
  static const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';
  static const PLACEHOLDER_IMAGE_URL =
      'blob:https://www.pngfuel.com/5e3dae69-7ade-4e65-b1ab-8a2cd4eedc6c';

  static MovieItem fromJson(dynamic element) {
    return MovieItem(
      id: element['id'],
      title: element['title'],
      genreIDs: element['genre_ids'],
      imageUrl: element['poster_path'] == null
          ? null
          : '$IMAGE_URL/${element['poster_path']}',
      overview: element['overview'],
      releaseDate: element['release_date'] == null
          ? DateTime.parse('0000-00-00')
          : DateTime.tryParse(element['release_date']),
      originalLanguage: element['original_language'],
      status: element['release_date'] == null ? 'Not Released' : 'Released',
      mediaType: element['media_type'],
      voteAverage: element['vote_average'] + 0.0,
      // voteAverage: 9.3,
      voteCount: element['vote_count'],
      // popularity: 9.3
    );
  }

  static MovieItem fromJsonDetails(dynamic json) {
    return MovieItem(
      id: json['id'],
      title: json['title'],
      genreIDs: json['genres'],
      // genreIDs: null,
      imageUrl: json['poster_path'] == null
          ? null
          : '$IMAGE_URL/${json['poster_path']}',
      overview: json['overview'],
      releaseDate: json['release_date'] == null
          ? DateTime.parse('0000-00-00')
          : DateTime.tryParse(json['release_date']),
      originalLanguage: json['original_language'],
      status: json['release_date'] == null ? 'Not Released' : 'Released',
      mediaType: json['media_type'],
      voteAverage: json['vote_average'] + 0.0,
      // voteAverage: 9.3,
      duration: json['runtime'],
      voteCount: json['vote_count'],
      budget: json['budget'],
      homepage: json['homepage'],
      revenue: json['revenue'],
      cast: json['credits']['cast'],
      reviews: json['reviews']['results'],
      productionCompanies: json['production_companies'],
      productionContries: json['production_countries'],
      similar: json['similar']['results'],
      recommendations: json['recommendations']['results'],
      popularity: json['popularity'] + 0.0,
    );
  }

  @override
  String toString() {
    return 'budget: $budget\n revenue:$revenue\n productionCompanies: $productionCompanies\similar: $similar\n'; // \n overview: $overview\n vote_average: $voteAverage\n release_date: $releaseDate
  }
}

class Movies with ChangeNotifier {
  static const API_KEY = '0ce2331b7a1f2dd735ece9351d3fa34c';
  static const BASE_URL = 'https://api.themoviedb.org/3/movie';

  // List of trending and upcoming movies with less detail
  List<MovieItem> _upcomingMovies = [];
  List<MovieItem> _trendingMovies = [];

  // Movie all details, recommendation, similar etc
  MovieItem _detailedMovie;
  List<MovieItem> _recommendations = [];
  List<MovieItem> _similar = [];

  // getters
  List<MovieItem> get upcomingMovies {
    return [..._upcomingMovies];
  }

  List<MovieItem> get trendingMovies {
    return [..._trendingMovies];
  }

  MovieItem get movieDetails {
    return _detailedMovie;
  }

  List<MovieItem> get recommended {
    return [..._recommendations];
  }

  List<MovieItem> get similar {
    return [..._similar];
  }

  // functions
  Future<void> fetchTrendingMovies() async {
    //https://api.themoviedb.org/3/trending/all/day?api_key=0ce2331b7a1f2dd735ece9351d3fa34c
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url =
        'https://api.themoviedb.org/3/trending/all/day?api_key=$API_KEY';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _trendingMovies.add(MovieItem.fromJson(element));
    });
    // print('length movies(trending) -------------> ' + trendingMoviesLength().toString());
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies(int page) async {
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url = '$BASE_URL/upcoming?api_key=$API_KEY&language=en-US&page=$page';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _upcomingMovies.add(MovieItem.fromJson(element));
    });
    // print('length movies(upcoming) -------------> ' + upcomingMoviesLength().toString());
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

  MovieItem findByIdTrending(int id) {
    return _trendingMovies.firstWhere((element) => element.id == id);
  }

  Future<void> getMovieDetails(int id) async {
    final url =
        'https://api.themoviedb.org/3/movie/$id?api_key=$API_KEY&language=en-US&append_to_response=credits%2Crecommendations,similar,reviews';

    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    _detailedMovie = MovieItem.fromJsonDetails(responseData);

    // _detailedMovie.reviews.forEach((element) { 
    //   print('Actor: -----------------> ${element['author']}');
    //   print('content: -----------------> ${element['content']}');
    // });

    _recommendations.clear();
    _similar.clear();

    _detailedMovie.similar.forEach((element) {
      _similar.add(MovieItem.fromJson(element));
    });

    _detailedMovie.recommendations.forEach((element) {
      _recommendations.add(MovieItem.fromJson(element));
    });

    notifyListeners();

    // print(response.body);
  }
}
