import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_movies/providers/movies.dart';

class ListItemModel {
  String title;
  double genre;
  int releaseDate;
  String imageURL;
  String mediaType;
  int runtime;

  ListItemModel();

  ListItemModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        genre = json['genre'],
        releaseDate = json['releaseDate'],
        imageURL = json['imageURL'],
        mediaType = json['mediaType'],
        runtime = json['runtime'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'genre': genre ?? 'N/A',
        'imageURL': imageURL,
        'mediaType': mediaType,
        'releaseDate': releaseDate,
        'runtime': runtime,
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
    {
      'title': 'Watched',
      'data': [],
    },
    {
      'title': 'To Watch',
      'data': [],
    },
  ];

  List<Map<String, dynamic>> get moviesLists {
    return _moviesLists;
  }

  void addNewItem(int index, MovieItem item) {
    // _moviesLists.firstWhere((element) {
    //   return element['title'] == title;
    // });
    // print('item ------------> ${item.title}');
    // _moviesLists[index]['data'].add(item);
    _moviesLists[index]['data'].add({
      'title': item.title,
      'genre': item.genreIDs[0] ?? 'N/A',
      'imageURL': item.posterUrl,
      'mediaType': item.mediaType,
      'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
      'runtime': item.duration ?? 0,
    });
    notifyListeners();
  }

  void addNewListToMovies(String title) {
    _moviesLists.add({
      'title': title,
      'data': [],
    });
    notifyListeners();
  }

  void deleteList(String title) {
    moviesLists.removeWhere((element) {
      return element['title'] == title;
    });
    notifyListeners();
  }

  void encode() {
    // Map<String, dynamic> map = {};
    var enc = json.encode(moviesLists);
    print(enc);
  }

  void addToPrefs() async {
    print('-----> ${json.encode(moviesLists)}');
    SharedPreferences prefs = await _prefs;
    prefs.setString('lists', json.encode(moviesLists));
  }

  void printPrefs() async {
    SharedPreferences prefs = await _prefs;
    var res = prefs.getString('lists');
    print(res);
  }
}
