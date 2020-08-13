import 'package:flutter/material.dart';
import 'package:e_movies/consts/consts.dart';
class MovieModel {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String overview;
  final DateTime date;
  final List<dynamic> genreIDs;
  final String originalLanguage;
  final bool status;
  final double voteAverage;
  final int voteCount;

  int duration;
  int budget;
  String homepage;
  double popularity;
  int revenue;
  List<dynamic> images;
  List<dynamic> videos;
  List<dynamic> reviews;
  List<dynamic> productionCompanies;
  List<dynamic> productionContries;
  List<dynamic> cast;
  List<dynamic> crew;
  List<dynamic> recommendations;
  List<dynamic> similar;

  String character; // for cast details page movies

  MovieModel({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    this.backdropUrl,
    @required this.genreIDs,
    @required this.overview,
    @required this.date,
    @required this.originalLanguage,
    @required this.status,
    @required this.voteAverage,
    @required this.voteCount,
    this.crew,
    this.images,
    this.videos,
    this.duration,
    this.homepage,
    this.cast,
    this.productionCompanies,
    this.productionContries,
    this.recommendations,
    this.similar,
    this.popularity,
    this.reviews,
    this.character,
  });

  static MovieModel fromJson(json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ??= json['name'],
      genreIDs: json['genre_ids'] ??= json['genres'],
      // genreIDs: null,
      posterUrl: json['backdrop_path'] == null
          ? null
          : '$IMAGE_URL/${json['poster_path']}',
      backdropUrl: json['backdrop_path'] == null
          ? ''
          : '$IMAGE_URL/${json['backdrop_path']}',
      overview: json['overview'],
      date: (json['release_date'] == null || json['release_date'] == '')
          ? null
          : DateTime.parse(json['release_date']),

      // : json['release_date'],
      // ? DateTime.tryParse(json['release_date'])
      // : null,
      originalLanguage: json['original_language'],
      status: json['release_date'] != null,
      voteAverage:
          json['vote_average'] == null ? 0 : json['vote_average'] + 0.0,
      videos: json['videos'] == null ? null : json['videos']['results'],
      images: json['images'] == null ? null : json['images']['backdrops'],
      // voteAverage: 9.3,
      duration: json['runtime'],
      voteCount: json['vote_count'],
      homepage: json['homepage'],
      cast: json['credits'] == null ? null : json['credits']['cast'],
      crew: json['credits'] == null ? null : json['credits']['crew'],
      reviews: json['reviews'] == null ? null : json['reviews']['results'],
      productionCompanies: json['production_companies'],
      productionContries: json['production_countries'],
      similar: json['similar'] == null ? [] : json['similar']['results'],
      recommendations: json['recommendations'] == null
          ? []
          : json['recommendations']['results'],
      popularity: json['popularity'] == null ? 0 : json['popularity'] + 0.0,
      // popularity: 9.3
      character: json['character'],
    );
  }

  @override
  String toString() {
    return 'title: $title\n id:$id\n'; // \n overview: $overview\n vote_average: $voteAverage\n release_date: $releaseDate
  }
}