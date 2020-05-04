import 'package:e_movies/pages/tv/tv_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/providers/tv.dart' as tv;

class TVItem extends StatelessWidget {
  final tv.TVItem item;
  final bool withFooter;
  final bool tappable;
  TVItem({
    this.item,
    this.withFooter = true,
    this.tappable = true,
  });

  // Functions
  String getGenreName(List<dynamic> genreIds) {
    String str = 'N/A';
    if (genreIds == null || genreIds.length == 0) return 'N/A';
    if (MOVIE_GENRES.containsKey(genreIds[0])) {
      str = MOVIE_GENRES[genreIds[0]];
    }
    if(str == 'Documentary') {
      str = 'Docu...';
    }
    return str;
    
  }

  String _formatDate(DateTime date) {
    return date == null ? 'N/A' : date.year.toString();
  }

  Route _buildRoute() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: item),
      pageBuilder: (context, animation, secondaryAnimation) => TVDetailsScreen(),
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

  void _navigate(BuildContext context) {
    // print('ontap ---------------> ');
    Navigator.of(context).push(_buildRoute());
  }

  Widget _buildBackgroundImage(
      BuildContext context, BoxConstraints constraints) {
        // print('BackgroundImage -----------> ${constraints.maxWidth}');
    return GestureDetector(
      onTap: tappable ? () => _navigate(context) : null,
      child: Card(
          color: BASELINE_COLOR,
          shadowColor: Colors.white30,
          elevation: 5,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: item.posterUrl == null
      ? PlaceHolderImage(item.name)
      : CachedNetworkImage(
          imageUrl: item.posterUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Center(
              child: SpinKitCircle(
                color: Theme.of(context).accentColor,
                size: LOADING_INDICATOR_SIZE,
              ),
            );
          },
        ),
        ),
    );
  }

  String _getRatings(double rating) {
    return rating == null ? 'N/A' : rating.toString();
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kItemTitle,
          ),
        SizedBox(height: 5),
        // Text(
        //   _formatDate(movie.firstAirDate),
        //   style: kSubtitle1,
        // ),
        // SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white38)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Text(
                  getGenreName(item.genreIDs),
                  style: kSubtitle1,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Text(
                      _getRatings(item.voteAverage),
                      style: kSubtitle1,
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.favorite_border, color: Colors.red),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        return Column(
          children: [
            Container(
              // width: double.infinity,
              height: withFooter ? constraints.maxHeight * 0.75 : constraints.maxHeight,
              width: constraints.maxWidth,
              child: _buildBackgroundImage(context, constraints),
            ),
            if (withFooter)
              Container(                
                height: constraints.maxHeight * 0.25,
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: _buildFooter(context),
              ),
          ],
        );
      },
    );
  }
}
