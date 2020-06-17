import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/screens/movie/movie_details_screen.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedMovieItem extends StatelessWidget {
  final dynamic item;
  SearchedMovieItem(this.item);

  Route _buildRoute(dynamic item, [bool searchHistoryItem = false]) {
    // if not search history item create initData for the tv show details screen
    InitData initData = InitData.formObject(item);
    return PageRouteBuilder(
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) => MovieDetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        // var curve = Curves.bounceIn;
        var tween =
            Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        Provider.of<Search>(context, listen: false).addToSearchHistory(item);
        Navigator.of(context).push(_buildRoute(item));
      },
      child: ListTile(
        isThreeLine: false,
        leading: Container(
          height: 65,
          width: 50,
          child: item.posterUrl == null
              ? PlaceHolderImage(item.title)
              : CachedNetworkImage(
                  imageUrl: item.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item.title ?? 'N/A',
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            color: Colors.white.withOpacity(0.87),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: <Widget>[
            Text(item.voteAverage == null ? 'N/A' : item.voteAverage.toString(),
                style: kSubtitle1),
            SizedBox(width: 5),
            Icon(Icons.favorite_border, color: Theme.of(context).accentColor)
          ],
        ),
        trailing: Text(
            item.date == null ? 'N/A' : item.date.year.toString(),
            style: kSubtitle1),
      ),
    );
  }
}
