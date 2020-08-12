import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/cast_model.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:flutter/material.dart';


class TrendingActors extends StatelessWidget {
  final List<CastModel> actors;
  const TrendingActors({
    this.actors,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      itemCount: actors.length > 20 ? 20 : actors.length,
      itemBuilder: (ctx, i) {        
        return CastItem(actors[i]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}