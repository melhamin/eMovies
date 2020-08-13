import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/review_model.dart';
import 'package:e_movies/widgets/review_item.dart';
import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  final MovieModel movie;
  Reviews(this.movie);

  List<ReviewModel> extractReviews() {
    List<ReviewModel> reviews = [];
    if (movie.reviews != null) {
      movie.reviews.forEach((element) {
        reviews.add(ReviewModel.fromJson(element));
      });
    }

    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    final reviews = extractReviews();
    return ListView.separated(
      separatorBuilder: (_, i) => SizedBox(height: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (_, i) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
          color: ONE_LEVEL_ELEVATION,
          child: ReviewItem(item: reviews[i]),
        );
      },
    );
  }
}
