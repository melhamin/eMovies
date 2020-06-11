import 'dart:convert';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/cast.dart';
import 'package:e_movies/providers/tv.dart';
import 'package:http/http.dart' as http;
import 'package:e_movies/providers/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_movies/providers/init_data.dart';

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

  static const SEARCH_HISTORY = 'search_history';
  static const TOP_MOVIE_GENRES = 'top_movie_genres';

  List<MovieItem> _movies = [];
  List<TVItem> _tvShows = [];
  List<ActorItem> _actors = [];

  List<InitialData> _recentSearches = [];
  List<int> _myTopMovieGenres = [];

  List<MovieItem> get movies {
    return _movies;
  }

  List<TVItem> get tvShows {
    return _tvShows;
  }

  List<ActorItem> get actors {
    return _actors;
  }

  List<InitialData> get searchHistory {
    return _recentSearches;
  }

  List<int> get topMovieGenres {
    return _myTopMovieGenres;
  }

  void clearMovies() => _movies.clear();
  void clearSeries() => _tvShows.clear();
  void clearPeople() => _actors.clear();

  // Movies
  Future<void> searchMovies(String query, int page) async {
    final url =
        '$BASE_URL/search/movie?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&query=$query&page=$page&include_adult=false';

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
        '$BASE_URL/search/tv?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&query=$query&page=$page&include_adult=false';

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
        '$BASE_URL/search/person?api_key=${DotEnv().env['TMDB_API_KEY']}&language=en-US&query=$query&$page=1&include_adult=false';

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
      return element.id == item.id;
    }, orElse: () => null);

    // print('item exit ----------> $alreadyExist');
    // don't add to the list if already exist
    if (alreadyExist != null) return;

    _recentSearches.insert(0, InitialData.formObject(item));
    if (_recentSearches.length > 10) {
      _recentSearches.removeAt(_recentSearches.length - 1);
    }

    // add to myTopMovieGenres
    item.genreIDs.forEach((elem) {
      int currentValue = myTopMovieGenres[elem.toString()];
      myTopMovieGenres.update(elem.toString(), (value) {
        // print('elem -----> $elem, value --------> $value');
        return currentValue + 1; // add one to current value
      });
      saveTopMovieGenres(); // save to prefs
      loadTopMovieGenres();
    });

    notifyListeners();
    savePrefs();
  }

  void addToTopMovieGenres(InitialData item) {
    item.genreIDs.forEach((elem) {
      int currentValue = myTopMovieGenres[elem.toString()];
      myTopMovieGenres.update(elem.toString(), (value) {
        // print('elem -----> $elem, value --------> $value');
        return currentValue + 1; // add one to current value
      });
      saveTopMovieGenres(); // save to prefs
      loadTopMovieGenres();
    });
    notifyListeners();
  }

  void removeSearchHistoryItem(int index) {
    _recentSearches.removeAt(index);
    notifyListeners();
    savePrefs();
  }

  void clearSearchHistory() {
    _recentSearches.clear();
    notifyListeners();
    savePrefs();
  }

  void loadSearchHistory() async {
    SharedPreferences prefs = await _prefs;
    final historyData = prefs.get(SEARCH_HISTORY);

    if (historyData != null && historyData.length > 0) {
      final lists = json.decode(historyData) as List<dynamic>;
      _recentSearches.clear();
      lists.forEach((element) {
        _recentSearches.add(InitialData.fromJson(element));
      });
    }

    loadTopMovieGenres();

    notifyListeners();
  }

  void loadTopMovieGenres() async {
    SharedPreferences prefs = await _prefs;
    final topMovieGenres = prefs.get(TOP_MOVIE_GENRES);
    if (topMovieGenres != null) myTopMovieGenres = json.decode(topMovieGenres);
    // get top 4 genres
    final list = myTopMovieGenres.values.toList();
    final keys = [];
    myTopMovieGenres.forEach((key, value) {
      keys.add(int.parse(key));
    });
    // intialize list to hold first four indexes
    final List<int> temp = [0, 1, 2, 3];
    for (int i = 4; i < list.length; i++) {
      int t = list[i];
      // check if t is bigger than list at index index
      int res = temp.indexWhere((index) => t > list[index]);
      // if is bigger then change elemnt at index res to new value t
      if (res != -1) temp[res] = i;
    }
    // update my top genres list
    _myTopMovieGenres.clear();
    temp.forEach((element) {
      _myTopMovieGenres.add(keys[element]);
    });

    notifyListeners();
  }

  void savePrefs() async {
    SharedPreferences prefs = await _prefs;
    var lists = [];
    _recentSearches.forEach((element) {
      lists.add(InitialData.toJson(element));
    });

    print(myTopMovieGenres);

    prefs.setString(SEARCH_HISTORY, json.encode(lists));
  }

  void saveTopMovieGenres() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(TOP_MOVIE_GENRES, json.encode(myTopMovieGenres));
  }

  void clearPrefs() async {
    // SharedPreferences prefs = await _prefs;
    // prefs.clear();
    // notifyListeners();
  }

  //
  Map<String, dynamic> myTopMovieGenres = {
    '28': 0,
    '12': 0,
    '16': 0,
    '35': 0,
    '80': 0,
    '99': 0,
    '18': 0,
    '10751': 0,
    '14': 0,
    '36': 0,
    '27': 0,
    '10402': 0,
    '9648': 0,
    '10749': 0,
    '878': 0,
    '10770': 0,
    '53': 0,
    '10752': 0,
    '37': 0,
  };
}
