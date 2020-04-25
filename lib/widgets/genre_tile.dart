import 'package:e_movies/pages/genre_item.dart';
import 'package:flutter/material.dart';

class GenreTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int genreId;

  GenreTile({this.title, this.imageUrl, this.genreId});

  Route _buildRoute() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: genreId),
      pageBuilder: (context, animation, secondaryAnimation) => GenreItem(),
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

  void _onTap(BuildContext context) {
    Navigator.of(context).push(_buildRoute());
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            width: double.infinity,            
            child: GridTile(              
              child: FadeInImage(
                image: AssetImage(imageUrl),
                placeholder: AssetImage('assets/images/placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
      onTap: () => _onTap(context),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
