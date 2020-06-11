import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/init_data.dart';
import 'package:e_movies/screens/movie/movie_details_screen.dart';
import 'package:e_movies/screens/my_lists_screen.dart';
import 'package:e_movies/screens/tv/tv_details_screen.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';


/// 
class ListDataItem extends StatelessWidget {
  final InitialData initData;
  ListDataItem(this.initData);

  Route _buildRoute() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) => initData.mediaType == MediaType.Movie ?
          MovieDetailsScreen() : TVDetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(
            1, 0); // if x > 0 and y = 0 transition is from right to left
        var end =
            Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
        var tween = Tween(begin: begin, end: end);
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
    // print(data);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_buildRoute());
      },
      highlightColor: Colors.black,
      splashColor: Colors.black,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 80,
          child: initData.posterUrl == null
              ? PlaceHolderImage(initData.title)
              : CachedNetworkImage(
                  imageUrl: initData.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          initData.title,
          style: kTitleStyle2,
        ),
        subtitle: Text(
          initData.genreIDs == null ? 'N/A' :
          '${MOVIE_GENRES[initData.genreIDs[0]]}' ,
          style: kSubtitle1,
        ),
        trailing: Text(
          '${initData.releaseDate.year}',
          style: kSubtitle1,
        ),
      ),
    );
  }
}
