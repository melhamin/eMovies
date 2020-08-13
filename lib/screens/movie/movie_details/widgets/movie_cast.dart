import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/screens/movie/cast/cast_details_screen.dart';
import 'package:e_movies/screens/search/all_actors_screen.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:e_movies/widgets/section_title.dart';
import 'package:flutter/material.dart';

class MovieCast extends StatelessWidget {
  final MovieModel movie;
  MovieCast({this.movie});

  List<CastModel> extractCast() {
    List<CastModel> cast = [];
    if (movie.cast != null) {
      movie.cast.forEach((element) {
        cast.add(CastModel(
          id: element['id'],
          name: element['name'],
          character: element['character'],
          imageUrl: element['profile_path'],
          job: element['job'],
        ));
      });
    }
    return cast;
  }

  Route _buildRoute(Widget toPage, [dynamic args]) {
    return MaterialPageRoute(
      builder: (context) => toPage,
      settings: RouteSettings(arguments: args),
    );
  }


  @override
  Widget build(BuildContext context) {
    final cast = extractCast();
    return Column(
      children: [
        SectionTitle(
          title: 'Cast',
          onTap: () {
            Navigator.of(context).push(_buildRoute(CastDetailsScreen(cast)));
          },
          topPadding: 0,
          bottomPadding: 0,
        ),
        Container(
          color: ONE_LEVEL_ELEVATION,
          height: 110,
          child: GridView.builder(
            itemCount: cast.length,
            itemBuilder: (ctx, i) => CastItem(cast[i]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              // mainAxisSpacing: 5,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
