import 'dart:convert';

import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/models/tv_model.dart';
import 'package:e_movies/models/video_model.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/consts/consts.dart';



class TV with ChangeNotifier {
  List<TVModel> _trending = [];
  List<TVModel> _onAirToday = [];
  List<TVModel> _topRated = [];
  List<TVModel> _forKids = [];
  List<TVModel> _genre = [];

  TVModel _details;
  List<TVModel> _similar = [];
  List<VideoModel> _videos = [];
  // List<CastModel> _cast = [];
  // List<CastModel> _crew = [];

  // Getters

  TVModel get details {
    return _details;
  }

  List<TVModel> get trending {
    return _trending;
  }

  List<TVModel> get onAirToday {
    return _onAirToday;
  }

  List<TVModel> get topRated {
    return _topRated;
  }

  List<TVModel> get forKids {
    return _forKids;
  }

  List<TVModel> get genre {
    return _genre;
  }

  List<TVModel> get similar {
    return _similar;
  }

  List<VideoModel> get videos {
    return _videos;
  } 
  // List<CastModel> get cast {
  //   return _cast;
  // }

  // List<CastModel> get crew {
  //   return _cast;
  // }

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
        _trending.add(TVModel.fromJson(element));
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
        _onAirToday.add(TVModel.fromJson(element));
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
        _topRated.add(TVModel.fromJson(element));
      });

      // print(_popular);

      // print(showData);
    } catch (error) {
      print('TV - fetchTopRated error -----------> $error ');
    }
    notifyListeners();
  }

  Future<void> getVideos(int id) async {
    // final url =
        // '$BASE_URL/tv/$id/videos?api_key=${DotEnv().env['API_KEY']}&language=en-US';
        // 'https://api.themoviedb.org/3'
    final url = 'https://api.themoviedb.org/3/tv/$id/videos?api_key=${DotEnv().env['API_KEY']}&language=en-US';
    try {
      final response = await http.get(url);
      print('response --------> ${response.body}');
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

  Future<void> getDetails(int id) async {
    final url =
        '$BASE_URL/tv/$id?api_key=${DotEnv().env['API_KEY']}&language=en-US&append_to_response=credits,Cimages,Cvideos,images,similar,reviews&include_image_language=en,null';
    try {
      final response = await http.get(url);
      // print('getDetails credits ------------------------->');
      // print('response ---------> ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // final data = responseData['results'];
      // print('details --------------->  ${data}');
      // print('getDetails credits -------------------------> ${responseData['credits']['crew']}');
      _details = TVModel.fromJson(responseData);
      // print('reviews ---------> ${responseData['reviews']}');
      // print('id----------> ${responseData['id']}');

      // get cast and crew details

      // // final crewData = responseData[]
      // cast.clear();
      // crew.clear();
      // if (details.cast != null) {
      //   print('cast ------> ${details.cast}');
      //   details.cast.forEach((element) {
      //     // print('crew/ ---------> ${element['character']} ');
      //     _cast.add(CastItem(
      //       id: element['id'],
      //       name: element['name'],
      //       character: element['character'],
      //       imageUrl: element['profile_path'],
      //       job: element['job'],
      //     ));
      //   });
      // }

      // if (details.crew != null) {
      //   // print('crew ------> ${details.crew}');
      //   details.crew.forEach((element) {
      //     // print('crew/ ---------> ${element['character']} ');
      //     _crew.add(CastItem(
      //       id: element['id'],
      //       name: element['name'],
      //       imageUrl: element['profile_path'],
      //       job: element['job'],
      //     ));
      //   });
      // }

      

      // get similar movies
      final similarTVs = responseData['similar']['results'];
      similarTVs.forEach((element) {
        _similar.add(TVModel.fromJson(element));
      });
    } catch (error) {
      print('TV - getDetails error -----------> $error ');
    }
    notifyListeners();
  }

  Future<void> fetchForKids(int page) async {
    final url =
        '$BASE_URL/discover/tv?api_key=${DotEnv().env['API_KEY']}&language=en-US&sort_by=popularity.desc&page=$page&with_genres=10762';
    try {
      final response = await http.get(url);
      // print(response.body);

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];
      // print('toprated ------------> $data');

      if (page == 1) {
        _forKids.clear();
      }

      data.forEach((element) {
        _forKids.add(TVModel.fromJson(element));
      });
    } catch (error) {
      print('TV - forKids error -------------> $error');
    }
  }

  Future<void> getGenre(int id, int page) async {
    final url =
        '$BASE_URL/discover/tv?api_key=${DotEnv().env['API_KEY']}&language=en-US&sort_by=popularity.desc&page=$page&with_genres=$id';
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
        _genre.add(TVModel.fromJson(element));
      });
    } catch (error) {
      print('TV - getGenre error -------------> $error');
    }
  }

  void clearGenre() {
    _genre.clear();
    notifyListeners();
  }

}
