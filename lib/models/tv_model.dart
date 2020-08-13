import 'package:flutter/material.dart';
import 'package:e_movies/consts/consts.dart';
class TVModel {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String overview;
  final DateTime date;
  final List<dynamic> genreIDs;
  final String originalLanguage;
  final String status;
  final double voteAverage;
  final int voteCount;
  final String mediaType;

  List<dynamic> createdBy;
  List<dynamic> seasons;
  bool inProduction;
  DateTime lastAirDate;
  List<dynamic> networks;
  List<dynamic> episodRuntime;
  String homepage;
  double popularity;

  List<dynamic> images;
  List<dynamic> videos;
  List<dynamic> reviews;
  // List<dynamic> productionCompanies;
  // List<dynamic> productionContries;
  List<dynamic> cast;
  List<dynamic> crew;
  List<dynamic> recommendations;
  List<dynamic> similar;

  String character; // for cast details page movies

  TVModel({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    this.backdropUrl,
    @required this.genreIDs,
    @required this.overview,
    @required this.date,
    @required this.originalLanguage,
    @required this.voteAverage,
    @required this.voteCount,
    this.crew,
    this.seasons,
    this.episodRuntime,
    this.images,
    this.videos,
    this.createdBy,
    this.inProduction,
    this.homepage,
    this.lastAirDate,
    this.cast,
    this.status,
    this.mediaType,
    // this.productionCompanies,
    // this.productionContries,
    this.networks,
    this.popularity,
    this.recommendations,
    this.similar,
    this.reviews,
    this.character,
  });

  static TVModel fromJson(json) {
    return TVModel(
      id: json['id'],
      title: json['name'] ??= json['name'],
      genreIDs: json['genre_ids'] ??= json['genres'],
      // genreIDs: null,
      posterUrl: json['backdrop_path'] == null
          ? null
          : '$IMAGE_URL/${json['poster_path']}',
      backdropUrl: json['backdrop_path'] == null
          ? ''
          : '$IMAGE_URL/${json['backdrop_path']}',
      overview: json['overview'],
      date: (json['first_air_date'] == null || json['first_air_date'] == '')
          ? null
          : DateTime.parse(json['first_air_date']),

      lastAirDate:
          (json['last_air_date'] == null || json['last_air_date'] == '')
              ? null
              : DateTime.parse(json['last_air_date']),
      // : json['release_date'],
      // ? DateTime.tryParse(json['release_date'])
      // : null,
      episodRuntime: json['episode_run_time'],
      seasons: json['seasons'],
      originalLanguage: json['original_language'],
      status: json['status'],
      voteAverage:
          json['vote_average'] == null ? 0 : json['vote_average'] + 0.0,
      videos: json['videos'] == null ? null : json['videos']['results'],
      images: json['images'] == null ? null : json['images']['backdrops'],
      voteCount: json['vote_count'],
      homepage: json['homepage'],
      cast: json['credits'] == null ? null : json['credits']['cast'],
      crew: json['credits'] == null ? null : json['credits']['crew'],
      reviews: json['reviews'] == null ? null : json['reviews']['results'],
      inProduction: json['in_production'],
      networks: json['networks'],
      createdBy: json['created_by'],
      // productionCompanies: json['production_companies'],
      // productionContries: json['production_countries'],
      similar: json['similar'] == null ? [] : json['similar']['results'],
      recommendations: json['recommendations'] == null
          ? []
          : json['recommendations']['results'],
      popularity: json['popularity'] == null ? 0 : json['popularity'] + 0.0,
      // popularity: 9.3
      character: json['character'],
      mediaType: 'tv',
    );
  }
}