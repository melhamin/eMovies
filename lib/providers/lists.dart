import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_movies/providers/movies.dart';

class ListItemModel {
  int id;
  String title;
  double genre;
  int releaseDate;
  String posterUrl;
  String backdropUrl;
  String mediaType;
  int runtime;
  double voteAverage;

  ListItemModel();

  ListItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        genre = json['genre'],
        releaseDate = json['releaseDate'],
        posterUrl = json['posterUrl'],
        backdropUrl = json['backdropUrl'],
        mediaType = json['mediaType'],
        voteAverage = json['voteAverage'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'genre': genre ?? 'N/A',
        'posterUrl': posterUrl,
        'mediaType': mediaType,
        'releaseDate': releaseDate,
        'voteAverage': voteAverage,
      };
}

class ListItem {
  final String title;
  final int items;

  ListItem({this.title, this.items});
}

class Lists with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Map<String, dynamic>> _lists = [];

  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get lists {
    return _lists;
  }

  List<Map<String, dynamic>> get favorites {
    return _favorites;
  }

  Future<void> loadLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loadedLists = prefs.getString('lists');
    final favorites = prefs.getString('favorites');    

    if(favorites != null && favorites.length > 0) {
      final favoritesData = json.decode(favorites) as List<dynamic>;
      _favorites.clear();
      
      favoritesData.forEach((element) { 
        _favorites.add(element);
      });
    }

    if (loadedLists != null && loadedLists.length > 0) {
      final listsData = json.decode(loadedLists) as List<dynamic>;
      _lists.clear();
      listsData.forEach((element) {
        _lists.add(element);
      });
    }
    notifyListeners();
  }

  bool addToFavorites(dynamic item) {
    // bool result;
    _favorites.insert(0,{
      'id': item['id'],
      'title': item['title'],
      // 'genre': (item.genreIDs['length'] == 0 || item.genreIDs[0] == null) ? 'N/A' : item.genreIDs[0],
      'genre': item['genre'],
      'posterUrl': item['posterUrl'],
      'backdropUrl': item['backdropUrl'],
      'mediaType': item['mediaType'],
      // 'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
      'releaseDate': item['releaseDate'],
      'voteAverage': item['voteAverage']
    });

    notifyListeners();
    saveFavorites();

    return true;
  }

  bool isInFavorites(int id) {
    final temp = _favorites.firstWhere((element) {
      return element['id'] == id;
    }, orElse: () => null);

    return temp != null;    
  }

  void removeFavorites(int id) {
    _favorites.removeWhere((element) => element['id'] == id);

    notifyListeners();
    saveFavorites();
  }

  bool addNewItemToList(int listIndex, dynamic item) {
    bool result;

    // Check if item already in the list
    final itemData = _lists[listIndex]['data'];
    // print('itemData-----------------> $itemData');
    final exist = itemData.firstWhere((element) {
      return element['id'] == item['id'];
    }, orElse: () => null);

    if (exist == null) {
      _lists[listIndex]['data'].insert(0, {
        'id': item['id'],
        'title': item['title'],
        // 'genre': (item.genreIDs['length'] == 0 || item.genreIDs[0] == null) ? 'N/A' : item.genreIDs[0],
        'genre': item['genre'],
        'posterUrl': item['posterUrl'],
        'backdropUrl': item['backdropUrl'],
        'mediaType': item['mediaType'],
        // 'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
        'releaseDate': item['releaseDate'],
        'voteAverage': item['voteAverage']
      });
      result = true;
      // update preferences
      saveLists();
      notifyListeners();
    } else
      result = false;

    return result;
  }

  bool checkForExistence(String title) {
    final alreadyExist = _lists.firstWhere((element) {
      return element['title'] == title;
    }, orElse: () => null);

    return alreadyExist == null;
  }

  void addNewList(String title) {
    _lists.insert(0, {
      'title': title,
      'data': [],
    });
    // update prefrences
    saveLists();
    notifyListeners();
  }

  void deleteList(String title) {
    lists.removeWhere((element) {
      return element['title'] == title;
    });

    // update prefrences
    saveLists();
    notifyListeners();
  }

  void deleteItemFromList(String title, int itemId) {
    // get list with give title
    final list = _lists.firstWhere((element) {
      return element['title'] == title;
    });

    // remove desired item form the list
    list['data'].removeWhere((element) {
      print('element ---------> $element');
      return element['id'] == itemId;
    });

    // update preferences
    notifyListeners();
    saveLists();

  }

  void saveFavorites() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('favorites', json.encode(_favorites));
  }

  void saveLists() async {
    // print('-----> ${json.encode(moviesLists)}');
    SharedPreferences prefs = await _prefs;
    prefs.setString('lists', json.encode(_lists));
  }

  void printPrefs() async {
    SharedPreferences prefs = await _prefs;
    var res = prefs.getString('lists');
    print(res);
  }

  void deleteAllPrefs() async {
    SharedPreferences prefs = await _prefs;
    prefs.clear();
    notifyListeners();
  }
}
