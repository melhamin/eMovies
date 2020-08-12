import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/widgets/image_view.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:e_movies/widgets/route_builder.dart';
import 'package:flutter/material.dart';

class MovieImages extends StatelessWidget {
  final MovieModel movie;
  const MovieImages({
    Key key,
    this.movie,
  }) : super(key: key);

  List<String> extractImages() {
    List<String> images = [];
    if (movie.images != null) {
      movie.images.forEach((element) {
        images.add(IMAGE_URL + element['file_path']);
      });
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final images = extractImages();
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      // controller: _scrollController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(BuildRoute.buildRoute(toPage: ImageView(images)));
          },
          child: CachedNetworkImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
            fadeInCurve: Curves.fastOutSlowIn,
            placeholder: (context, url) {
              return Center(
                child: LoadingIndicator(),
              );
            },
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2 / 3,
        mainAxisSpacing: 10,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}