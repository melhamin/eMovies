import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MovieItem {
  @required
  final int id;
  @required
  final String title;
  @required
  final String imageUrl;
  @required
  final String overview;
  final DateTime releaseDate;
  @required
  final List<dynamic> genreIDs;
  @required
  final String originalLanguage;
  @required
  final double voteAverage;
  @required
  final int voteCount;
  @required
  final String mediaType;

  final double popularity;

  MovieItem({
    this.id,
    this.title,
    this.imageUrl,
    this.genreIDs,
    this.overview,
    this.releaseDate,
    this.originalLanguage,
    this.mediaType,
    this.voteAverage,
    this.voteCount,
    this.popularity,
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
    var url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
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
