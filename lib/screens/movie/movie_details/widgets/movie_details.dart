import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetails extends StatelessWidget {
  final MovieModel movie;
  const MovieDetails({
    this.movie,
    Key key,
  }) : super(key: key);

  String _getGenres(List<dynamic> ids) {
    if (ids == null || ids.length == 0) return 'N/A';
    int length = ids.length < 3 ? ids.length : 3;
    String res = '';
    for (int i = 0; i < length; i++) {
      res = res + MOVIE_GENRES[ids[i]['id']] + ', ';
    }
    res = res.substring(0, res.lastIndexOf(','));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: LINE_COLOR),
          top: BorderSide(color: LINE_COLOR, width: 0.5),
        ),
        color: ONE_LEVEL_ELEVATION,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.all(0),
            title: Text('Release Date', style: kSubtitle1),
            trailing: Text(
                movie.date != null
                    ? DateFormat.yMMMd().format(movie.date)
                    : 'N/A',
                style: kBodyStyle),
          ),
          Divider(
            indent: DEFAULT_PADDING,
            endIndent: DEFAULT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Runtime', style: kSubtitle1),
            trailing:
                Text(movie.duration.toString() + ' min', style: kBodyStyle),
          ),
          Divider(
            indent: DEFAULT_PADDING,
            endIndent: DEFAULT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Rating', style: kSubtitle1),
            trailing: Text(
                movie.voteAverage == 0 ? 'NR' : movie.voteAverage.toString(),
                style: kBodyStyle),
          ),
          Divider(
            indent: DEFAULT_PADDING,
            endIndent: DEFAULT_PADDING,
            height: 0,
            thickness: 0.5,
            color: LINE_COLOR,
          ),
          ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.only(left: 15),
            title: Text('Genres', style: kSubtitle1),
            trailing: Text(_getGenres(movie.genreIDs), style: kBodyStyle),
          ),
        ],
      ),
    );
  }
}