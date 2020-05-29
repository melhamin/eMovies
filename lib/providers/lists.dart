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

  List<Map<String, dynamic>> _moviesLists = [
    // {
    //   'title': 'Watched',
    //   'data': [],
    // },
    // {
    //   'title': 'To Watch',
    //   'data': [],
    // },
  ];

  List<Map<String, dynamic>> get moviesLists {
    return _moviesLists;
  }

  Future<void> loadLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('lists');

    if (data != null && data.length > 0) {
      final lists = json.decode(data) as List<dynamic>;
      _moviesLists.clear();
      lists.forEach((element) {
        _moviesLists.add(element);
      });
    }
    notifyListeners();
  }

  void addNewItemToList(int index, dynamic item) {
    _moviesLists[index]['data'].add({
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

    // update preferences
    savePrefs();
    notifyListeners();
  }

  void addNewList(String title) {
    _moviesLists.insert(0, {
      'title': title,
      'data': [],
    });
    
    // update prefrences
    savePrefs();
    notifyListeners();
  }

  void deleteList(String title) {
    moviesLists.removeWhere((element) {
      return element['title'] == title;
    });

    // update prefrences
    savePrefs();
    notifyListeners();
  }

  void deleteItemFromList(String title, int itemId) {
    // get list with give title
    final list = _moviesLists.firstWhere((element) {
      return element['title'] == title;
    });

    // remove desired item form the list
    list['data'].removeWhere((element) {
      print('element ---------> $element');
      return element['id'] == itemId;
    });

    // update preferences
    savePrefs();

    notifyListeners(); 


  }


  void savePrefs() async {
    print('-----> ${json.encode(moviesLists)}');
    SharedPreferences prefs = await _prefs;
    prefs.setString('lists', json.encode(moviesLists));
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
