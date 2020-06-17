import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/screens/my_lists_screen.dart';

class InitData {
  int id;
  String title;
  List genreIDs;
  String posterUrl;
  String backdropUrl;
  DateTime releaseDate;
  double voteAverage;
  int voteCount;
  MediaType mediaType;

  InitData({
    this.id,
    this.title,
    this.genreIDs,
    this.posterUrl,
    this.backdropUrl,
    this.mediaType,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
  });

  static InitData formObject(data) {
    return InitData(
      id: data.id,
      title: data.title ?? 'N/A',
      genreIDs: data.genreIDs,
      posterUrl: data.posterUrl,
      backdropUrl: data.backdropUrl,
      mediaType: data is MovieModel ? MediaType.Movie : MediaType.TV,
      releaseDate: data.date,
      voteAverage: data.voteAverage,
      voteCount: data.voteCount,
    );
  }

  static InitData fromJson(json) {
    return InitData(
      id: json['id'],
      title: json['title'],
      genreIDs: json['genreIDs'],
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      mediaType: json['mediaType'] == MediaType.Movie.toString() ? MediaType.Movie : MediaType.TV,
      // releaseDate: DateTime.parse(json['releaseDate']),
      releaseDate: DateTime.now(),
      voteAverage: json['voteAverage'],
      voteCount: json['voteCount'],
    );
  }

  static Map<String, dynamic> toJson(dynamic data) {    
    return {
      'id': data.id,
      'title': data.title,
      'genreIDs': data.genreIDs,
      'posterUrl': data.posterUrl,
      'backdropUrl': data.backdropUrl,
      'mediaType': data.mediaType.toString(),
      'releaseDate': data.releaseDate.toIso8601String(),
      'voteAverage': data.voteAverage,
      'voteCount': data.voteCount,
    };
  }

  @override
  String toString() {    
    return this.title + ' - ' + this.id.toString();
  }
}



