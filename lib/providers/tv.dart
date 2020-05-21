import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/consts/consts.dart';

class TVItem {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String overview;
  final DateTime firstAirDate;
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

  TVItem({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    this.backdropUrl,
    @required this.genreIDs,
    @required this.overview,
    @required this.firstAirDate,
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

  static TVItem fromJson(json) {
    return TVItem(
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
      firstAirDate:
          (json['first_air_date'] == null || json['first_air_date'] == '')
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

class TV with ChangeNotifier {
  List<TVItem> _trending = [];
  List<TVItem> _onAirToday = [];
  List<TVItem> _topRated = [];
  List<TVItem> _genre = [];
  List<TVItem> _similar = [];

  TVItem _details;

  // Getters

  TVItem get details {
    return _details;
  }

  List<TVItem> get trending {
    return _trending;
  }

  List<TVItem> get onAirToday {
    return _onAirToday;
  }

  List<TVItem> get topRated {
    return _topRated;
  }

  List<TVItem> get genre {
    return _genre;
  }

  List<TVItem> get similar {
    return _similar;
  }

  // Functions

  Future<void> fetchPopular(int page) async {
    final url =
        '$BASE_URL/tv/popular?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];

      if (page == 1) {
        _trending.clear();
      }

      data.forEach((element) {
        _trending.add(TVItem.fromJson(element));
      });

      // print(_popular);

      // print(showData);
    } catch (error) {
      print('TV - fetchPopular error -----------> $error ');
    }

    notifyListeners();
  }

  Future<void> fetchOnAirToday(int page) async {
    final url =
        '$BASE_URL/tv/on_the_air?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];

      if (page == 1) {
        _onAirToday.clear();
      }

      data.forEach((element) {
        _onAirToday.add(TVItem.fromJson(element));
      });

      // print(_popular);

      // print(showData);
    } catch (error) {
      print('TV - fetchOnAir error -----------> $error ');
    }

    notifyListeners();
  }

  Future<void> fetchTopRated(int page) async {
    final url =
        '$BASE_URL/tv/top_rated?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];
      // print('toprated ------------> $data');

      if (page == 1) {
        _topRated.clear();
      }

      data.forEach((element) {
        _topRated.add(TVItem.fromJson(element));
      });

      // print(_popular);

      // print(showData);
    } catch (error) {
      print('TV - fetchTopRated error -----------> $error ');
    }
    notifyListeners();
  }

  Future<void> getDetails(int id) async {
    final url =
        '$BASE_URL/tv/$id?api_key=${DotEnv().env['API_KEY']}&language=en-US&append_to_response=credits,Cimages,Cvideos,images&include_image_language=en,null';
    try {
      final response = await http.get(url);
      // print('getDetails credits ------------------------->');
      // print('response ---------> ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // final data = responseData['results'];
      // print('details --------------->  ${data}');
      // print('getDetails credits -------------------------> ${responseData['credits']['crew']}');
      _details = TVItem.fromJson(responseData);
    } catch (error) {
      print('TV - getDetails error -----------> $error ');
    }
    notifyListeners();
  }



  Future<void> getGenre(int id, int page) async {
    final url = 'https://api.themoviedb.org/3/discover/tv?api_key=${DotEnv().env['API_KEY']}&language=en-US&sort_by=popularity.desc&page=$page&with_genres=$id';
    try {
      final response = await http.get(url);
      print(response.body);      

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];
      // print('toprated ------------> $data');

      if (page == 1) {
        _genre.clear();
      }

      data.forEach((element) {
        _genre.add(TVItem.fromJson(element));
      });        

    } catch (error) {
      print('TV - getGenre error -------------> $error');
    }
  }

  Future<void> getSimilar(int id) async {    
    final url = 'https://api.themoviedb.org/3/tv/$id/similar?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=1';
    try {
      final response = await http.get(url);
      // print(response.body);      

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];
      // print('toprated ------------> $data');

     
        _similar.clear();     

      data.forEach((element) {
        _similar.add(TVItem.fromJson(element));
      });        

    } catch (error) {
      print('TV - getGenre error -------------> $error');
    }
  }
  
}
