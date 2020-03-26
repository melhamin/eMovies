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
  final DateTime release_date;
  @required
  final List<dynamic> genreIDs;
  @required
  final String original_language;
  @required
  final double vote_average;
  @required
  final int vote_count;
  @required
  final String media_type;

  final double popularity;

  MovieItem({
    this.id,
    this.title,
    this.imageUrl,
    this.genreIDs,
    this.overview,
    this.release_date,
    this.original_language,
    this.media_type,
    this.vote_average,
    this.vote_count,
    this.popularity,
  });

  @override
  String toString() {
    return 'id: $id\n title:$title\n imageUrl: $imageUrl\n overview: $overview\n vote_average: $vote_average\n release_date: $release_date\n';
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
        release_date: element['release_date'] == null
            ? DateTime.parse('0000-00-00')
            : DateTime.tryParse(element['release_date']),
        original_language: element['original_language'],
        media_type: element['media_type'],
        vote_average: element['vote_average'],
        vote_count: element['vote_count'],
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
}
