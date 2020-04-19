import 'package:e_movies/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:e_movies/consts/consts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../pages/details_page.dart';

class MovieItem extends StatelessWidget {  
  final movie;
  final bool withoutFooter;

  MovieItem({    
    this.movie, 
    this.withoutFooter = false,   
  });

  Route _buildRoute(int id) {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: id),
      pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1, 0); // if x > 0 and y = 0 transition is from right to left
        var end = Offset.zero;          // if y > 0 and x = 0 transition is from bottom to top
        // var curve = Curves.bounceIn;
        var tween = Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
        var offsetAnimation = animation.drive(tween);        

        return SlideTransition(          
          position: offsetAnimation,
          child: child,
        );
      },      
    );
  }

  String getGenreName(int genreId) {
    return GENRES[genreId];
  }

  void _navigate(BuildContext context, int id) {
    Navigator.of(context).push(_buildRoute(id));
  }

  String _formatDate(DateTime date) {
    return date == null ? 'Unk' : intl.DateFormat.yMMMd().format(date);
  }

  Widget _buildBackgroundImage(BuildContext context, String imageUrl) {
    return imageUrl == null
        ? Image.asset('assets/images/poster_placeholder.png', fit: BoxFit.cover)
        : FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          fadeInCurve: Curves.easeInOutSine,
          image: imageUrl,
        );
  }

  Widget _buildFooter(BuildContext context, double screenWidth, String title,
      int genreId, DateTime date) {
    return Positioned.directional(
      width: screenWidth / 2,
      height: 75,
      bottom: 0,
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 1),
                Color.fromRGBO(0, 0, 0, 0.1),
              ]),
          // backgroundBlendMode: BlendMode.colorBurn,
        ),
        constraints: BoxConstraints(maxWidth: screenWidth / 2 - 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title == null ? 'Unk' : title,
                style: Theme.of(context).textTheme.headline5,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              FittedBox(
                child: Text(
                  getGenreName(genreId),
                  style: Theme.of(context).textTheme.subtitle1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              FittedBox(
                child: Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.subtitle1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _navigate(context, movie.id),
      child: ClipRRect(
        child: GridTile(
          child: Stack(
            children: <Widget>[
              _buildBackgroundImage(context, movie.imageUrl),
              if(!withoutFooter)
              _buildFooter(
                context,
                screenWidth,
                movie.title,
                movie.genreIDs.isNotEmpty ? movie.genreIDs[0] : -1,
                movie.releaseDate,
              )
            ],
          ),
        ),
      ),
    );
  }
}
