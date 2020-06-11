import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/consts/consts.dart';

class CastItem {
  final int id;
  final String name;
  final String imageUrl;

  String character;
  String job;

  CastItem({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    this.character,
    this.job,
  });

  static CastItem fromJson(json) {
    return CastItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['profile_path'],
      character: json['character'] ?? 'N/A',
      job: json['job'] ?? 'N/A',
    );
  }
}

class Person {
  final String name;
  final DateTime birthday;
  final String placeOfBirth;
  final String biography;
  final movies;  

  Person({
    this.name,
    this.birthday,
    this.placeOfBirth,
    this.biography,
    this.movies,
  });
}

class Cast with ChangeNotifier {

  final API_KEY = DotEnv().env['API_KEY'];

  Person person;
  List<MovieItem> _movies = [];
  List<CastItem> _popularPeople = [];


  Person get getPerson {
    return person;
  }

  List<MovieItem> get getMovies {
    return [..._movies];
  }

  List<CastItem> get popularPeople {
    return [..._popularPeople];
  }

  Future<void> getPersonDetails(int id) async {    
      final personUrl = '$BASE_URL/person/$id?api_key=$API_KEY&language=en-US';
      final moviesUrl = '$BASE_URL/person/$id/movie_credits?api_key=$API_KEY&language=en-US';

    try {
      final personResponse = await http.get(personUrl);
      final personData = json.decode(personResponse.body) as Map<String, dynamic>;
      // print('person data ----------> ${personData}');

      final moviesResponse = await http.get(moviesUrl);
      final moviesData = json.decode(moviesResponse.body) as Map<String, dynamic>;
      final fetchedMovies = moviesData['cast'];
      // print('movies data ----------> ${fetchedMovies}');

      _movies.clear();
      fetchedMovies.forEach((element) {
        _movies.add(MovieItem.fromJson(element));
        // print('added element id ------------------> ${element['id']}');
      });
      
      
      person = Person(
        name: personData['name'],
        birthday: DateTime.parse(personData['birthday']),
        biography: personData['biography'],
        placeOfBirth: personData['place_of_birth'],
        movies: _movies,
      );
      // print(personResponse.body);

    notifyListeners();
    }
    catch (error) {
      print('cast provider error -------------> $error');
      throw error;
    }

  } 
  Future<void> getPopularPeople(int page) async {    
      final url = 'https://api.themoviedb.org/3/person/popular?api_key=$API_KEY&language=en-US&page=1';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;    
      final data = responseData['results'];

      // print('results -----------> $data');

      data.forEach((element) {
        _popularPeople.add(CastItem.fromJson(element));
      }); 

      // print('done---------> $_popularPeople');
     
    notifyListeners();
    }
    catch (error) {
      print('cast provider error -------------> $error');
      throw error;
    }

  } 





}
