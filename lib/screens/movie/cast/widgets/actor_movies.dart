import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/person_model.dart';
import 'package:e_movies/screens/movie/movie_details/movie_details_screen.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class ActorMovies extends StatelessWidget {
  final PersonModel item;
  final bool isLoading;
  ActorMovies({this.item, this.isLoading});

  Route _buildRoute(MovieModel item) {
    final initData = InitData.formObject(item);
    return MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(),
        settings: RouteSettings(arguments: initData));   
  }

  void _onTap(BuildContext context, MovieModel item) {
    Navigator.of(context).push(_buildRoute(item));
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final movies = item.movies;
    return isLoading
        ? _buildLoadingIndicator(context)
        : ListView.builder(
            itemCount: item.movies.length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).size.height * 0.4 + kToolbarHeight),
            itemBuilder: (context, i) {
              final temp = item.movies[i];
              return InkWell(
                onTap: () => _onTap(context, temp),
                splashColor: Colors.transparent,
                highlightColor: Colors.black,
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Container(
                    width: 70,
                    margin: const EdgeInsets.only(left: DEFAULT_PADDING),
                    color: BASELINE_COLOR,
                    child: temp.posterUrl == null
                        ? PlaceHolderImage(temp.title)
                        : CachedNetworkImage(
                            imageUrl: temp.posterUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    temp.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kBodyStyle,
                  ),
                  subtitle: RichText(
                    text: TextSpan(text: 'as ', style: kSubtitle2, children: [
                      TextSpan(
                          text: temp.character,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ))
                    ]),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: DEFAULT_PADDING),
                    child: Text(
                      temp.date == null
                          ? 'N/A'
                          : DateFormat.y().format(temp.date),
                      style: kSubtitle1,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
