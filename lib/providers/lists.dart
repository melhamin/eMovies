import 'dart:convert';

import 'package:e_movies/providers/init_data.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemModel {
  String title;
  List<InitialData> items;

  ListItemModel(String title) {
    this.title = title;
    this.items = [];
  }

  ListItemModel.fromJson(json) {
    this.title = json['title'];
    List<InitialData> temp = [];    

    for (int i = 0; i < json['data'].length; i++) {
      temp.add(InitialData.fromJson(json['data'][i]));
    }
    this.items = temp;    
  }

  List<InitialData> get getItems {
    return items;
  }

  @override
  String toString() {
    // print(items);
    String res = '';
    var aa = [];
    items.forEach((element) {
      aa.add(InitialData.toJson(element));
    });
    return aa.toString();
  }

  void addItem(InitialData newItem) {
    items.insert(0, newItem);
  }

  void removeItem(int id) {
    items.removeWhere((element) => element.id == id);
  }

  void removeAllItems() {
    items.clear();
  }

  List<Map<String, dynamic>> toMap() {
    List<Map<String, dynamic>> temp = [];
    items.forEach((item) {
      temp.add(InitialData.toJson(item));
    });    

    return temp;
  }
}

class ListItem {
  final String title;
  final int items;

  ListItem({this.title, this.items});
}

class Lists with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const MOVIE_LISTS = 'MoviesLists';
  static const FAVORITE_MOVIES = 'FavoriteMovies';
  static const TV_LISTS = 'TVLists';
  static const FAVORITE_TVS = 'FavoriteTVs';

  // Movies
  List<ListItemModel> _moviesLists = [];
  List<InitialData> _favoriteMovies = [];

  // Tv shows
  List<ListItemModel> _tvLists = [];
  List<InitialData> _favoriteTVs = [];

  // Movies getter
  List<ListItemModel> get moviesLists {
    return _moviesLists;
  }

  List<InitialData> get favoriteMovies {
    return _favoriteMovies;
  }

  // TV getters
  List<ListItemModel> get tvLists {
    return _tvLists;
  }

  List<InitialData> get favoriteTVs {
    return _favoriteTVs;
  }


  // Load all lists (movie & tv)
  Future<void> loadMovieLists() async {
    SharedPreferences prefs = await _prefs;

    // Load Favorite movies list
    final favoritesData = prefs.getString(FAVORITE_MOVIES);
    if (favoritesData != null) {
      _favoriteMovies.clear();
      final favorites = json.decode(favoritesData) as List<dynamic>;
      if (favorites != null && favorites.isNotEmpty) {
        _favoriteMovies.clear();
        favorites.forEach((element) {
          _favoriteMovies.add(InitialData.fromJson(element));
        });
      }
    }

    // load other lists
    final moviesData = prefs.getString(MOVIE_LISTS);
    if (moviesData != null) {
      _moviesLists.clear();      
      final movieLists = json.decode(moviesData) as List<dynamic>;
      movieLists.forEach((element) {
        _moviesLists.add(ListItemModel.fromJson(element));
      });
    }    
    notifyListeners(); 
  }

  ListItemModel getMovieList(String title) {
    return _moviesLists.firstWhere((element) => element.title == title);
  }

  // Favorite movies and other movie lists
  bool addToFavoriteMovies(InitialData item) {
    _favoriteMovies.insert(0, item);
    notifyListeners();
    saveFavoriteMovies();
    return true;
  }

  bool isFavoriteMovie(InitialData item) {
    var temp = _favoriteMovies.firstWhere((element) => element.id == item.id,
        orElse: () => null);
    return temp != null;
  }

  void removeFavoriteMovie(int id) {
    _favoriteMovies.removeWhere((element) => element.id == id);
    notifyListeners();
    saveFavoriteMovies();
  }

  bool addNewMovieToList(int listIndex, InitialData item) {
    final temp = _moviesLists[listIndex]
        .items
        .firstWhere((element) => element.id == item.id, orElse: () => null);

    if (temp != null) return false;
    _moviesLists[listIndex].addItem(item);
    notifyListeners();
    saveMovieLists();
    return true;
  }

  bool addNewMovieList(String title) {
    // check if item already exists in the list    
    final temp = _moviesLists.firstWhere((element) => element.title == title,
        orElse: () => null);
    if (temp != null) return false;

    _moviesLists.insert(0, ListItemModel(title));
    notifyListeners();
    saveMovieLists();
    return true;
  }

  void removeMovieList(String title) {
    _moviesLists.removeWhere((element) => element.title == title);
    notifyListeners();
    saveMovieLists();
  }

  void removeMovieFromList(String title, int itemId) {
    int index = _moviesLists.indexWhere((element) => element.title == title);
    _moviesLists[index].removeItem(itemId);
    notifyListeners();
    saveMovieLists();
  }

  void removeAllListItemsMovie(String title) {
    final list = _moviesLists.firstWhere((element) {
      return element.title == title;
    });
    list.removeAllItems();
    notifyListeners();
  }

  void saveFavoriteMovies() async {
    SharedPreferences prefs = await _prefs;
    var favorites = [];
    _favoriteMovies.forEach((element) {
      favorites.add(InitialData.toJson(element));
    });
    prefs.setString(FAVORITE_MOVIES, json.encode(favorites));
  }

  void saveMovieLists() async {
    SharedPreferences prefs = await _prefs;
    var movies = [];
    _moviesLists.forEach((element) {
      List<Map<String, dynamic>> data = element.toMap();
      final item = {
        'title': element.title,
        'data': data,
      };      
      movies.add(item);
    });
    
    prefs.setString(MOVIE_LISTS, json.encode(movies));
  }

  void printPrefs() async {}

  void deleteAllPrefs() async {
    SharedPreferences prefs = await _prefs;
    prefs.clear();
    notifyListeners();
  }

  // Favorite TV shows and other tv lists
  Future<void> loadTVLists() async {
    SharedPreferences prefs = await _prefs;

    // Load Favorite movies list
    final favoritesData = prefs.getString(FAVORITE_TVS);
    if (favoritesData != null) {
      _favoriteTVs.clear();
      final favorites = json.decode(favoritesData) as List<dynamic>;
      if (favorites != null && favorites.isNotEmpty) {
        _favoriteTVs.clear();
        favorites.forEach((element) {
          _favoriteTVs.add(InitialData.fromJson(element));
        });
      }
    }

    // load other lists
    final tvData = prefs.getString(TV_LISTS);
    if (tvData != null) {
      _tvLists.clear();      
      final tvLists = json.decode(tvData) as List<dynamic>;
      tvLists.forEach((element) {
        _tvLists.add(ListItemModel.fromJson(element));
      });
    }    
    notifyListeners(); 
  }

  ListItemModel getTVList(String title) {
    return _tvLists.firstWhere((element) => element.title == title);
  }


  // Favorite movies and other movie lists
  bool addToFavoriteTVs(InitialData item) {
    _favoriteTVs.insert(0, item);
    notifyListeners();
    saveFavoriteTVs();
    return true;
  }

  bool isFavoriteTV(InitialData item) {
    var temp = _favoriteTVs.firstWhere((element) => element.id == item.id,
        orElse: () => null);
    return temp != null;
  }

  void removeFavoriteTV(int id) {
    _favoriteTVs.removeWhere((element) => element.id == id);
    notifyListeners();
    saveFavoriteTVs();
  }

  void removeAllListItemsTV(String title) {
    final list = _tvLists.firstWhere((element) {
      return element.title == title;
    });
    list.removeAllItems();
    notifyListeners();
  }

  bool addNewTVToList(int listIndex, InitialData item) {
    final temp = _tvLists[listIndex]
        .items
        .firstWhere((element) => element.id == item.id, orElse: () => null);

    if (temp != null) return false;
    _tvLists[listIndex].addItem(item);
    notifyListeners();
    saveTVLists();
    return true;
  }

  bool addNewTVList(String title) {
    final temp = _tvLists.firstWhere((element) => element.title == title,
        orElse: () => null);
    if (temp != null) return false;

    _tvLists.insert(0, ListItemModel(title));
    notifyListeners();
    saveTVLists();
    return true;
  }

  void removeTVList(String title) {
    _tvLists.removeWhere((element) => element.title == title);
    notifyListeners();
    saveTVLists();
  }

  void removeTVFromList(String title, int itemId) {
    int index = _tvLists.indexWhere((element) => element.title == title);
    _tvLists[index].removeItem(itemId);
    notifyListeners();
    saveTVLists();
  }

  void saveFavoriteTVs() async {
    SharedPreferences prefs = await _prefs;
    var favorites = [];
    _favoriteTVs.forEach((element) {
      favorites.add(InitialData.toJson(element));
    });
    prefs.setString(FAVORITE_TVS, json.encode(favorites));
  }

  void saveTVLists() async {
    SharedPreferences prefs = await _prefs;
    var lists = [];
    _tvLists.forEach((element) {
      List<Map<String, dynamic>> data = element.toMap();
      final item = {
        'title': element.title,
        'data': data,
      };      
      lists.add(item);
    });
    
    prefs.setString(TV_LISTS, json.encode(lists));
  }
  
}
  