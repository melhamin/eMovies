import 'dart:convert';
import 'dart:async';

import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/review_model.dart';
import 'package:e_movies/models/video_model.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/consts/consts.dart';







class Movies with ChangeNotifier {
  // Environemnt Variables
  // final TMDB_API_KEY = DotEnv().env['API_KEYY'];

  List<MovieModel> _trending = [];
  List<MovieModel> _topRated = [];
  List<MovieModel> _upcoming = [];
  List<MovieModel> _inTheaters = [];
  List<MovieModel> _forKids = [];

  // Movie all details, recommendation, similar etc
  MovieModel _movieDetails;
  List<CastModel> _cast = [];
  List<MovieModel> _recommendations = [];
  List<MovieModel> _similar = [];
  List<ReviewModel> _reviews = [];

  List<VideoModel> _videos = [];

  // Genres
  List<MovieModel> _genre = [];

  // getters
  List<MovieModel> get genre {
    return _genre;
  }

  List<MovieModel> get topRated {
    return _topRated;
  }

  List<MovieModel> get trending {
    return _trending;
  }

  List<MovieModel> get upcoming {
    return _upcoming;
  }

  List<MovieModel> get inTheaters {
    return _inTheaters;
  }

  List<MovieModel> get forKids {
    return _forKids;
  }

  MovieModel get movieDetails {
    return _movieDetails;
  }

  List<CastModel> get cast {
    return _cast;
  }

  List<MovieModel> get recommended {
    return [..._recommendations];
  }

  List<MovieModel> get similar {
    return [..._similar];
  }

  List<ReviewModel> get reviews {
    return _reviews;
  }

  Future<void> fetchInTheaters(int page) async {
    final url =
        '$BASE_URL/movie/now_playing?api_key=${DotEnv().env['TMDB_API_KEY']}&page=$page';

    try {
      final response = await http.get(url);
      // print('pageno =---------------------> ${response.body}' );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final moviesData = responseData['results'];

      // When page reopened it will fetch page 1
      // so delete previous data to avoid duplicates
      if (page == 1) {
        _inTheaters.clear();
      }
      moviesData.forEach((element) {
        _inTheaters.add(MovieModel.fromJson(element));
      });
    } catch (error) {
      print('In Theaters error -----------> $error');
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchTrending(int page) async {
    // print('${DotEnv().env['TMDB_API_KEY']}');
    // final url =
    //     '$BASE_URL/movie/popular?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&page=$page';
    final url =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=${DotEnv().env['TMDB_API_KEY']}&page=$page';

    try {
      final response = await http.get(url);
      // print('pageno =---------------------> ${response.body}' );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final moviesData = responseData['results'];

      // When page reopened it will fetch page 1
      // so delete previous data to avoid duplicates
      if (page == 1) {
        _trending.clear();
      }

      moviesData.forEach((element) {
        // print('element -----------> ${element.toString()}');
        _trending.add(MovieModel.fromJson(element));
      });
      // print('_trending size------------------> ${_trending.length}');
      // print('length movies(trending) -------------> ' + trendingMoviesLength().toString());
    } catch (error) {
      print('In Theaters error -----------> $error');
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchUpcoming(int page) async {
    final url =
        '$BASE_URL/movie/upcoming?api_key=${DotEnv().env['TMDB_API_KEY']}&page=$page';

    try {
      final response = await http.get(url);
      // print('pageno =---------------------> ${response.body}' );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final moviesData = responseData['results'];

      // When page reopened it will fetch page 1
      // so delete previous data to avoid duplicates
      if (page == 1) {
        _upcoming.clear();
      }

      moviesData.forEach((element) {
        _upcoming.add(MovieModel.fromJson(element));
      });
    } catch (error) {
      print('fetchUpcoming error -----------> $error');
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchForKids(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&sort_by=popularity.desc&page=$page&with_genres=16';

    try {
      final response = await http.get(url);
      // print('pageno =---------------------> $page' );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final moviesData = responseData['results'];

      // When page reopened it will fetch page 1
      // so delete previous data to avoid duplicates
      if (page == 1) {
        _forKids.clear();
      }

      moviesData.forEach((element) {
        _forKids.add(MovieModel.fromJson(element));
      });
    } catch (error) {
      print('Top Rated Error -------------> $error');
    }
    notifyListeners();
  }

  Future<void> fetchTopRated(int page) async {
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$TMDB_API_KEY';
    final url =
        '$BASE_URL/movie/top_rated?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&page=$page';

    try {
      final response = await http.get(url);
      // print('pageno =---------------------> $page' );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final moviesData = responseData['results'];

      // When page reopened it will fetch page 1
      // so delete previous data to avoid duplicates
      if (page == 1) {
        _topRated.clear();
      }

      moviesData.forEach((element) {
        _topRated.add(MovieModel.fromJson(element));
      });
      // print('length movies(upcoming) -------------> ' + upcomingMoviesLength().toString());
    } catch (error) {
      print('Top Rated Error -------------> $error');
    }
    notifyListeners();
  }

  Future<void> getMovieDetails(int id) async {
    final url =
        '$BASE_URL/movie/$id?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&append_to_response=credits,similar,reviews,images&include_image_language=en,null';
    try {
      final response = await http.get(url);
      // print('MovieDetails ----------->- ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      _movieDetails = MovieModel.fromJson(responseData);

      _similar.clear();
      _cast.clear();                       

      if (_movieDetails.cast != null) {
      _movieDetails.cast.forEach((element) {
        // print('name/ ---------> ${element['character']} ');
        cast.add(CastModel(
          id: element['id'],
          name: element['name'],
          imageUrl: element['profile_path'],
          character: element['character'],
        ));
      });
    }



    if (_movieDetails.similar != null) {
        _movieDetails.similar.forEach((element) {
          _similar.add(MovieModel.fromJson(element));
        });
      }

      notifyListeners();
    } catch (error) {
      print('fetchMovieDetaisl error -----------> $error');
      throw error;
    }
    // print(response.body);
  }

  Future<void> fetchVideos(int id) async {
    final url =
        '$BASE_URL/movie/$id/videos?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final videoData = responseData['results'];

      _videos.clear();

      videoData.forEach((element) {
        _videos.add(VideoModel.fromJson(element));
      });
      // print(_videos);
    } catch (error) {
      print('fetchVideos error ----------------------> $error');
      throw error;
    }
  }

  List<VideoModel> get videos {
    return _videos;
  }

  // Fetch genres
  Future<void> getGenre(int id, int page) async {
    // print('DotEnv TMDB_API_KEY---------------> ${DotEnv().env['TMDB_API_KEY']}');
    // print('TMDB_API_KEY---------------> $TMDB_API_KEY');
    final url =
        '$BASE_URL/discover/movie?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$id';
    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // print('pageno =---------------------> $moviesData' );

    // When page reopened it will fetch page 1
    // so delete previous data to avoid duplicates
    if (page == 1) {
      _genre.clear();
    }

    moviesData.forEach((element) {
      _genre.add(MovieModel.fromJson(element));
    });
    // print('Action  -------------> ${response.body}');
    notifyListeners();
  }

  void clearGenre() {
    _genre.clear();
    // notifyListeners();
  }
}
