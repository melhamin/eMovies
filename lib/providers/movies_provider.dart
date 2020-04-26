import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/consts/consts.dart';

class MovieItem {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String overview;
  final DateTime releaseDate;
  final List<dynamic> genreIDs;
  final String originalLanguage;
  final bool status;
  final double voteAverage;
  final int voteCount;
  final String mediaType;

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

  MovieItem({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    this.backdropUrl,
    @required this.genreIDs,
    @required this.overview,
    @required this.releaseDate,
    @required this.originalLanguage,
    @required this.status,
    @required this.mediaType,
    @required this.voteAverage,
    @required this.voteCount,
    this.crew,
    this.images,
    this.videos,
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

  static MovieItem fromJson(dynamic json) {
    return MovieItem(
      id: json['id'],
      title: json['title'] ??= json['name'],
      genreIDs: json['genre_ids'] ??= json['genres'],
      // genreIDs: null,
      posterUrl: json['backdrop_path'] == null
          ? null
          : '$IMAGE_URL/${json['poster_path']}',
      backdropUrl: json['backdrop_path'] == null
          ? null
          : '$IMAGE_URL/${json['backdrop_path']}',
      overview: json['overview'],
      releaseDate: json['release_date'] == null ? DateTime.parse(json['first_air_date']) :
          DateTime.parse(json['release_date']),
          // : json['release_date'],
      // ? DateTime.tryParse(json['release_date'])
      // : null,
      originalLanguage: json['original_language'],
      status: json['release_date'] != null,
      mediaType: json['media_type'],
      voteAverage:
          json['vote_average'] == null ? 0 : json['vote_average'] + 0.0,
      videos: json['videos'] == null ? null : json['videos']['results'],
      images: json['images'] == null ? null : json['images']['backdrops'],
      // voteAverage: 9.3,
      duration: json['runtime'],
      voteCount: json['vote_count'],
      budget: json['budget'],
      homepage: json['homepage'],
      revenue: json['revenue'],
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
    );
  }

  @override
  String toString() {
    return 'budget: $budget\n revenue:$revenue\n productionCompanies: $productionCompanies\similar: $similar\n'; // \n overview: $overview\n vote_average: $voteAverage\n release_date: $releaseDate
  }
}

class MoviesProvider with ChangeNotifier {
  // List of trending and upcoming movies with less detail

  // List<MovieItem> _upcoming = [];

  List<MovieItem> _topRated = [];  


  // List<MovieItem> _trending = [];
  
  List<MovieItem> _inTheaters = [];    


  // Movie all details, recommendation, similar etc
  MovieItem _detailedMovie;
  List<MovieItem> _recommendations = [];
  List<MovieItem> _similar = [];

  // Genres
  List<MovieItem> _action = [];
  List<MovieItem> _adventure = [];
  List<MovieItem> _animation = [];
  List<MovieItem> _comedy = [];
  List<MovieItem> _crime = [];
  List<MovieItem> _drama = [];
  List<MovieItem> _family = [];
  List<MovieItem> _fantasy = [];
  List<MovieItem> _history = [];
  List<MovieItem> _documentary = [];
  List<MovieItem> _horror = [];
  List<MovieItem> _music = [];
  List<MovieItem> _mystery = [];
  List<MovieItem> _romance = [];
  List<MovieItem> _scifi = [];
  List<MovieItem> _thriller = [];
  List<MovieItem> _war = [];
  List<MovieItem> _western = [];

  // getters
  List<MovieItem> get topRated {
    return _topRated;
  }

  List<MovieItem> get inTheaters {
    return _inTheaters;      
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
  Future<void> fetchInTheaters(int page) async {
    //https://api.themoviedb.org/3/trending/all/day?api_key=0ce2331b7a1f2dd735ece9351d3fa34c
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url = '$BASE_URL/movie/now_playing?api_key=$API_KEY&language=en-US&page=$page';
    final response = await http.get(url);
    // print('pageno =---------------------> ${response.body}' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      // print('element -----------> ${element.toString()}');
      _inTheaters.add(MovieItem.fromJson(element));
    });
    // print('_trending size------------------> ${_trending.length}');
    // print('length movies(trending) -------------> ' + trendingMoviesLength().toString());
    notifyListeners();
  }

  Future<void> fetchTopRated(int page) async {
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url =
        '$BASE_URL/movie/top_rated?api_key=$API_KEY&language=en-US&page=$page';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _topRated.add(MovieItem.fromJson(element));
    });
    // print('length movies(upcoming) -------------> ' + upcomingMoviesLength().toString());
    notifyListeners();
  }

  // int upcomingMoviesLength() {
  //   return _upcomingMovies.length;
  // }

  // int trendingMoviesLength() {
  //   return _trendingMovies.length;
  // }

  // MovieItem findByIdUpcoming(int id) {
  //   return _upcomingMovies.firstWhere((element) => element.id == id);
  // }

  // MovieItem findByIdTrending(int id) {
  //   return _trendingMovies.firstWhere((element) => element.id == id);
  // }

  Future<void> getMovieDetails(int id) async {
    // final url =
    //     'https://api.themoviedb.org/3/movie/$id?api_key=$API_KEY&language=en-US&append_to_response=credits,videos,recommendations,similar,reviews';

    try {
      final url =
          '$BASE_URL/movie/$id?api_key=$API_KEY&language=en-US&append_to_response=credits,videos,recommendations,similar,reviews,images&include_image_language=en,null';

      final response = await http.get(url);
      // print('MovieDetails ----------->- ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      _detailedMovie = MovieItem.fromJson(responseData);
      // print('MovieDetails videos -------------->${_detailedMovie.videos}');

      // _detailedMovie.reviews.forEach((element) {
      //   print('Actor: -----------------> ${element['author']}');
      //   print('content: -----------------> ${element['content']}');
      // });

      // _recommendations.clear();
      _similar.clear();

      // try {
      if (_detailedMovie.similar != null) {
        _detailedMovie.similar.forEach((element) {
          _similar.add(MovieItem.fromJson(element));
        });
      }
      // } catch(error) {
      //   print('similarMovies fetch error --------------> $error');
      // }

      // _detailedMovie.recommendations.forEach((element) {
      //   _recommendations.add(MovieItem.fromJson(element));
      // });

      notifyListeners();
    } catch (error) {
      print('fetchMovieDetaisl error -----------> $error');
      throw error;
    }
    // print(response.body);
  }

  // Fetch genres
  Future<void> fetchActions(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=28';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _action.add(MovieItem.fromJson(element));
    });
    // print('Action  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get action {
    return _action;
  }

  Future<void> fetchAdventure(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=12';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _adventure.add(MovieItem.fromJson(element));
    });
    // print('adventure  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get adventrue {
    return _adventure;
  }

  Future<void> fetchComedy(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=35';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _comedy.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get comedy {
    return _comedy;
  }

  Future<void> fetchAnimation(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=16';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _animation.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get animation {
    return _animation;
  }

  Future<void> fetchCrime(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=80';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _crime.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get crime {
    return _crime;
  }

  Future<void> fetchFamily(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=10751';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _family.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get family {
    return _family;
  }

  Future<void> fetchDocumentary(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=99';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _documentary.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get documentary {
    return _documentary;
  }

  Future<void> fetchDrama(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=18';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _drama.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get drama {
    return _drama;
  }

  Future<void> fetchFantasy(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=14';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _fantasy.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get fantasy {
    return _fantasy;
  }

  Future<void> fetchHistory(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=36';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _history.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get history {
    return _history;
  }

  Future<void> fetchHorror(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=27';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _horror.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get horror {
    return _horror;
  }

  Future<void> fetchMusic(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=10402';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _music.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get music {
    return _music;
  }

  Future<void> fetchMystery(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=9648';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _mystery.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get mystery {
    return _mystery;
  }

  Future<void> fetchRomance(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=10749';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _romance.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get romance {
    return _romance;
  }

  Future<void> fetchSciFi(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=878';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _scifi.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get scifi {
    return _scifi;
  }

  Future<void> fetchThriller(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=53';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _thriller.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get thriller {
    return _thriller;
  }

  Future<void> fetchWar(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=10752';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _war.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get war {
    return _war;
  }

  Future<void> fetchWestern(int page) async {
    final url =
        '$BASE_URL/discover/movie?api_key=$API_KEY&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=37';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];
    moviesData.forEach((element) {
      _western.add(MovieItem.fromJson(element));
    });
    // print('Comedy  -------------> ${response.body}');
    notifyListeners();
  }

  List<MovieItem> get western {
    return _western;
  }

  Future<void> fetchGenres() async {
    await fetchActions(1);
    await fetchAdventure(1);
    await fetchComedy(1);
    await fetchAnimation(1);
    await fetchCrime(1);
    await fetchDocumentary(1);
    await fetchDrama(1);
    await fetchFamily(1);
    await fetchHistory(1);
    await fetchHorror(1);
    await fetchMusic(1);
    await fetchMystery(1);
    await fetchRomance(1);
    await fetchSciFi(1);
    await fetchThriller(1);
    await fetchWar(1);
    await fetchWestern(1);
  }
}
