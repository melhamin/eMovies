import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  @override
  String toString() {
    return 'id: $id\n title:$title\n imageUrl: $imageUrl\n overview: $overview\n vote_average: $voteAverage\n release_date: $releaseDate\n';
  }
}

class Movies with ChangeNotifier {
  static const API_KEY = '0ce2331b7a1f2dd735ece9351d3fa34c';
  static const IMAGE_WEIGHT = 'w500';
  static const IMAGE_URL = 'https://image.tmdb.org/t/p/$IMAGE_WEIGHT';

  List<MovieItem> _movies = [];  

  List<MovieItem> get movies {
    return [..._movies];
  }

  Future<void> fetch() async {
    final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final response = await http.get(url);

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    final List<MovieItem> loadedMovies = [];

    moviesData.forEach((element) {      
      loadedMovies.add(MovieItem(
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
        voteAverage: element['vote_average'],
        voteCount: element['vote_count'],
        popularity: element['popularity'],
      ));
      //   print(element['genre_ids']);
    });

    _movies = loadedMovies;

    notifyListeners();

    // _movies.forEach((element) {
    //   print(element.toString());
    // });
  }

  MovieItem findById(int id) {
    return _movies.firstWhere((element) => element.id == id);
  }

}
