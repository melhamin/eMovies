import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/consts/consts.dart';

class MovieItem {
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

  MovieItem({
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

  static MovieItem fromJson(json) {
    return MovieItem(
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

class VideoItem {
  final String id;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;

  VideoItem({
    this.id,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  static VideoItem fromJson(dynamic json) {
    return VideoItem(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
    );
  }
}

class Movies with ChangeNotifier {

  // Environemnt Variables
  // final API_KEY = DotEnv().env['API_KEYY'];

  List<MovieItem> _trending = [];
  List<MovieItem> _topRated = [];
  List<MovieItem> _upcoming = [];

  // Movie all details, recommendation, similar etc
  MovieItem _detailedMovie;
  List<MovieItem> _recommendations = [];
  List<MovieItem> _similar = [];

  List<VideoItem> _videos = [];

  // Genres
  List<MovieItem> _genre = [];    

  // getters
  List<MovieItem> get genre {
    return _genre;
  }
  List<MovieItem> get topRated {
    return _topRated;
  }

  List<MovieItem> get trending {
    return _trending;
  }

  List<MovieItem> get upcoming {
    return _upcoming;
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
  Future<void> fetchCategory(String category, int page) async {
    // print('${DotEnv().env['API_KEY']}');
    // final url =
    //     '$BASE_URL/movie/popular?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    final url = 'https://api.themoviedb.org/3/$category/movie/day?api_key=${DotEnv().env['API_KEY']}&page=$page';

    try {        
    final response = await http.get(url);
    // print('pageno =---------------------> ${response.body}' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // When page reopened it will fetch page 1 
    // so delete previous data to avoid duplicates
    if(page == 1) {
      _trending.clear();
    }

    moviesData.forEach((element) {
      // print('element -----------> ${element.toString()}');
      _trending.add(MovieItem.fromJson(element));
    });
    // print('_trending size------------------> ${_trending.length}');
    // print('length movies(trending) -------------> ' + trendingMoviesLength().toString());
    } catch (error) {
      print('In Theaters error -----------> $error');
      throw error;
    }
    notifyListeners();
  }
  Future<void> fetchTrending(int page) async {
    // print('${DotEnv().env['API_KEY']}');
    // final url =
    //     '$BASE_URL/movie/popular?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    final url = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${DotEnv().env['API_KEY']}&page=$page';

    try {        
    final response = await http.get(url);
    // print('pageno =---------------------> ${response.body}' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // When page reopened it will fetch page 1 
    // so delete previous data to avoid duplicates
    if(page == 1) {
      _trending.clear();
    }

    moviesData.forEach((element) {
      // print('element -----------> ${element.toString()}');
      _trending.add(MovieItem.fromJson(element));
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
    final url = '$BASE_URL/movie/upcoming?api_key=${DotEnv().env['API_KEY']}&page=$page';

    try {        
    final response = await http.get(url);
    // print('pageno =---------------------> ${response.body}' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // When page reopened it will fetch page 1 
    // so delete previous data to avoid duplicates
    if(page == 1) {
      _upcoming.clear();
    }

    moviesData.forEach((element) {      
      _upcoming.add(MovieItem.fromJson(element));
    });
    } catch (error) {
      print('fetchUpcoming error -----------> $error');
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchTopRated(int page) async {
    // final url = 'https://api.themoviedb.org/3/trending/all/week?api_key=$API_KEY';
    final url =
        '$BASE_URL/movie/top_rated?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=$page';
    
    try {
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // When page reopened it will fetch page 1 
    // so delete previous data to avoid duplicates
    if(page == 1) {
      _topRated.clear();
    }

    moviesData.forEach((element) {
      _topRated.add(MovieItem.fromJson(element));
    });
    // print('length movies(upcoming) -------------> ' + upcomingMoviesLength().toString());
    } catch (error) {
      print('Top Rated Error -------------> $error');
    }
    notifyListeners();
  }

  Future<void> getMovieDetails(int id) async {    
      final url =
          '$BASE_URL/movie/$id?api_key=${DotEnv().env['API_KEY']}&language=en-US&append_to_response=credits,similar,reviews,images&include_image_language=en,null';
    try {

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

  // Future<void> getSimilar(int id) async {    
  //   final url = 'https://api.themoviedb.org/3/movie/$id/similar?api_key=${DotEnv().env['API_KEY']}&language=en-US&page=1';
  //   try {
  //     final response = await http.get(url);
  //     print(response.body);      

  //     final responseData = json.decode(response.body) as Map<String, dynamic>;
  //     final data = responseData['results'];
  //     // print('toprated ------------> $data');

     
  //       _similar.clear();     

  //     data.forEach((element) {
  //       _similar.add(MovieItem.fromJson(element));
  //     });        

  //   } catch (error) {
  //     print('Movies - getSimilar error -------------> $error');
  //   }
  // }

  Future<void> fetchVideos(int id) async {
    final url = '$BASE_URL/movie/$id/videos?api_key=${DotEnv().env['API_KEY']}&language=en-US';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final videoData = responseData['results'];

      _videos.clear();

      videoData.forEach((element) {
        _videos.add(VideoItem.fromJson(element));
      });
      // print(_videos);
    } catch (error) {
      print('fetchVideos error ----------------------> $error');
      throw error;
    }
  }

  List<VideoItem> get videos {
    return _videos;
  }

  // Fetch genres
  Future<void> getGenre(int id, int page) async {
    print('DotEnv API_KEY---------------> ${DotEnv().env['API_KEY']}');
    // print('API_KEY---------------> $API_KEY');
    final url =
        '$BASE_URL/discover/movie?api_key=${DotEnv().env['API_KEY']}&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$id';
    final response = await http.get(url);
    // print('pageno =---------------------> $page' );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final moviesData = responseData['results'];

    // When page reopened it will fetch page 1 
    // so delete previous data to avoid duplicates
    if(page == 1) {
      _genre.clear();
    }

    moviesData.forEach((element) {
      _genre.add(MovieItem.fromJson(element));
    });
    // print('Action  -------------> ${response.body}');
    notifyListeners();
  }

  
}
