import 'dart:convert';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:http/http.dart' as http;
import 'package:e_movies/providers/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActorItem {
  final int id;
  final String name;
  final String department;
  final String imageUrl;

  ActorItem({
    this.id,
    this.name,
    this.imageUrl,
    this.department,
  });

  static ActorItem fromJson(json) {
    return ActorItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['profile_path'],
      department: json['known_for_department'],
    );
  }
}

class Search with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<MovieItem> _movies = [];
  List<TVItem> _tvShows = [];
  List<ActorItem> _actors = [];

  List<Map<String, dynamic>> _recentSearches = [];

  List<MovieItem> get movies {
    return _movies;
  }

  List<TVItem> get tvShows {
    return _tvShows;
  }

  List<ActorItem> get actors {
    return _actors;
  }

  List<Map<String, dynamic>> get searchHistory {
    return _recentSearches;
  }

  void clearMovies() => _movies.clear();
  void clearSeries() => _tvShows.clear();
  void clearPeople() => _actors.clear();

  // Movies
  Future<void> searchMovies(String query, int page) async {
    final url =
        '$BASE_URL/search/movie?api_key=${DotEnv().env['API_KEY']}&language=en-US&query=$query&page=$page&include_adult=false';

    if (query.isNotEmpty)
      try {
        final response = await http.get(url);
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final data = responseData['results'];

        if (page == 1) _movies.clear();

        data.forEach((element) {
          _movies.add(MovieItem.fromJson(element));
        });

        // print(_movies);
      } catch (error) {
        print('searchMovies error  --------------------> $error');
        throw error;
      }

    notifyListeners();

    // return _movies;
  }

  Future<void> searchTVShows(String query, int page) async {
    final url =
        '$BASE_URL/search/tv?api_key=${DotEnv().env['API_KEY']}&language=en-US&query=$query&page=$page&include_adult=false';

    if (query.isNotEmpty)
      try {
        final response = await http.get(url);
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final data = responseData['results'];

        if (page == 1) _tvShows.clear();

        data.forEach((element) {
          _tvShows.add(TVItem.fromJson(element));
        });
      } catch (error) {
        print('searchTVShows error  --------------------> $error');
        throw error;
      }
    notifyListeners();
  }

  Future<void> searchPerson(String query, int page) async {
    final url =
        '$BASE_URL/search/person?api_key=${DotEnv().env['API_KEY']}&language=en-US&query=$query&$page=1&include_adult=false';

    if (query.isNotEmpty)
      try {
        final response = await http.get(url);
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final data = responseData['results'];
        
        // print('actors data--------> $data');

        if (page == 1) _actors.clear();

        data.forEach((element) {
          _actors.add(ActorItem.fromJson(element));
        });
      } catch (error) {
        print('searchPerson error  --------------------> $error');
        throw error;
      }
    notifyListeners();
  }

  void addToSearchHistory(dynamic item) async {

    // check if item is already in the list
    final alreadyExist = _recentSearches.firstWhere((element) { 
      return element['id'] == item.id;
    }, orElse: () => null);

    print('item exit ----------> $alreadyExist');
    // don't add to the list if already exist
    if(alreadyExist != null) return; 

    _recentSearches.insert(0, {
      'id': item.id,
      'title': item.title,
      'genre': (item.genreIDs.length == 0 || item.genreIDs[0] == null)
          ? 'N/A'
          : item.genreIDs[0],
      // 'genre': item.genreIDs == null ?,
      'posterUrl': item.posterUrl,
      'backdropUrl': item.backdropUrl,
      // 'mediaType': item['mediaType'],
      'mediaType': 'movie',
      // 'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
      'releaseDate': item.date.year.toString(),
      'voteAverage': item.voteAverage,
    });
    if (_recentSearches.length > 10) {
      _recentSearches.removeAt(_recentSearches.length - 1);
    }

    savePrefs();
  }

  void removeSearchHistoryItem(int index) {
    _recentSearches.removeAt(index);
    savePrefs();
    notifyListeners();
  }

  void clearSearchHistory() {
    _recentSearches.clear();
    savePrefs();
    notifyListeners();
  }

  void loadSearchHistory() async {
    SharedPreferences prefs = await _prefs;
    final data = prefs.get('search_history');

    if (data != null && data.length > 0) {
      final lists = json.decode(data) as List<dynamic>;
      _recentSearches.clear();
      lists.forEach((element) {
        _recentSearches.add(element);
      });
    }
    notifyListeners();
  }

  void savePrefs() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('search_history', json.encode(_recentSearches));
  }
}
