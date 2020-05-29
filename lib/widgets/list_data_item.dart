import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';

class ListDataItem extends StatelessWidget {

  final dynamic data;
  ListDataItem(this.data);

   Route _buildRoute() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: data),
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailsScreen(),
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
          width: 70,
          height: 60,
          child: CachedNetworkImage(
            imageUrl: data['posterUrl'],
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          data['title'],
          style: kTitleStyle2,
        ),
        subtitle: Text(
          MOVIE_GENRES[data['genre']] == null ? 'N/A' : '${MOVIE_GENRES[data['genre']]}',
          style: kSubtitle1,
        ),
        trailing: Text('${data['releaseDate']}', style: kSubtitle1,),      
      ),
    );
  }
}
