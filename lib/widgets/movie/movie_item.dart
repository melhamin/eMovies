import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/movies.dart' as prov;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../pages/movie/movie_details_screen.dart';
import '../placeholder_image.dart';

class MovieItem extends StatelessWidget {
  final prov.MovieItem item;
  final bool withoutDetails;

  MovieItem({
    this.item,
    this.withoutDetails = false,
  });

  String getGenreName() {
    return (item.genreIDs == null || item.genreIDs.length == 0) ? 'N/A':
     MOVIE_GENRES[item.genreIDs[0]];
  }

  String _getRatings(double rating) {
    return rating == null ? 'N/A' : rating.toString();
  }

  String _formatDate(DateTime date) {
    return date == null ? 'N/A' : date.year.toString();
  }

  Route _buildRoute() {
    final initData = {
      'id': item.id,
      'title': item.title,
      'genre': (item.genreIDs.length == 0 || item.genreIDs[0] == null)
          ? 'N/A'
          : item.genreIDs[0],
      'posterUrl': item.posterUrl,
      'backdropUrl': item.backdropUrl,
      'mediaType': 'movie',
      'releaseDate': item.releaseDate.year.toString() ?? 'N/A',
      'voteAverage': item.voteAverage,
    };
    return PageRouteBuilder(
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailsScreen(),
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
    return LayoutBuilder(
      builder: (context, constraints) {        
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(_buildRoute());
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              item.posterUrl == null
                  ? PlaceHolderImage(item.title)
                  : CachedNetworkImage(
                      imageUrl: item.posterUrl,
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return Center(
                          child: SpinKitCircle(
                            color: Theme.of(context).accentColor,
                            size: LOADING_INDICATOR_SIZE,
                          ),
                        );
                      },
                    ),
                    if(!withoutDetails)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 0, 0, 0.8),
                    Color.fromRGBO(0, 0, 0, 0.1),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
              if(!withoutDetails)
              Positioned(
                bottom: 10,
                left: 5,
                child: Container(
                  width: constraints.maxWidth,   
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Helvatica',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.87),
                        ),
                      ),
                      Text(
                        _formatDate(item.releaseDate),
                        style: kSubtitle1,
                      ),
                      Container(
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white38)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 2),
                                child: Text(
                                  getGenreName(),
                                  style: kSubtitle1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    _getRatings(item.voteAverage),
                                    style: kSubtitle1,
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.favorite_border,
                                      color: Theme.of(context).accentColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}









// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:e_movies/pages/movie/movie_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:e_movies/providers/movies.dart' as prov;
// import 'package:e_movies/consts/consts.dart';
// import 'package:e_movies/widgets/placeholder_image.dart';

// class MovieItem extends StatelessWidget {
//   final prov.MovieItem movie;
//   final bool withFooter;
//   final bool tappable;
//   MovieItem({
//     this.movie,
//     this.withFooter = true,
//     this.tappable = true,
//   });

//   // Functions
//   String getGenreName(List<dynamic> genreIds) {
//     String str = 'N/A';
//     if (genreIds == null || genreIds.length == 0) return 'N/A';
//     if (MOVIE_GENRES.containsKey(genreIds[0])) {
//       str = MOVIE_GENRES[genreIds[0]];
//     }
//     if(str == 'Documentary') {
//       str = 'Docu...';
//     }
//     return str;
    
//   }

//   String _formatDate(DateTime date) {
//     return date == null ? 'N/A' : date.year.toString();
//   }

//   Route _buildRoute() {
//     final initData = {
//       'id': movie.id,
//       'title': movie.title,
//       'genre': (movie.genreIDs.length == 0 || movie.genreIDs[0] == null) ? 'N/A' : movie.genreIDs[0],
//       'posterUrl': movie.posterUrl,
//       'backdropUrl': movie.backdropUrl,
//       'mediaType': movie.mediaType,
//       'releaseDate': movie.releaseDate.year.toString() ?? 'N/A',
//       'voteAverage': movie.voteAverage,
//     };
//     return PageRouteBuilder(
//       settings: RouteSettings(arguments: initData),
//       pageBuilder: (context, animation, secondaryAnimation) => MovieDetailsScreen(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = const Offset(
//             1, 0); // if x > 0 and y = 0 transition is from right to left
//         var end =
//             Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
//         // var curve = Curves.bounceIn;
//         var tween =
//             Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
//         var offsetAnimation = animation.drive(tween);

//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//     );
//   }

//   void _navigate(BuildContext context) {
//     // print('ontap ---------------> ');
//     Navigator.of(context).push(_buildRoute());
//   }

//   Widget _buildBackgroundImage(
//       BuildContext context, BoxConstraints constraints) {
//     return GestureDetector(
//       onTap: tappable ? () => _navigate(context) : null,
//       child: Card(
//         color: BASELINE_COLOR,
//         shadowColor: Colors.white30,
//         elevation: 5,
//         // shape: RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         // ),
//         child: movie.posterUrl == null
//             ? PlaceHolderImage(movie.title)
//             : CachedNetworkImage(
//                 imageUrl: movie.posterUrl,
//                 fit: BoxFit.fill,
//                 placeholder: (context, url) {
//                   return Center(
//                     child: SpinKitCircle(
//                       color: Theme.of(context).accentColor,
//                       size: LOADING_INDICATOR_SIZE,
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   String _getRatings(double rating) {
//     return rating == null ? 'N/A' : rating.toString();
//   }

//   Widget _buildFooter(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//             movie.title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: kItemTitle,
//           ),
//         SizedBox(height: 10),
//         Text(
//           _formatDate(movie.releaseDate),
//           style: kSubtitle1,
//         ),
//         SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.white38)),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
//                 child: Text(
//                   getGenreName(movie.genreIDs),
//                   style: kSubtitle1,
//                 ),
//               ),
//             ),
//             Padding(
//                 padding: EdgeInsets.only(right: 5),
//                 child: Row(
//                   children: [
//                     Text(
//                       _getRatings(movie.voteAverage),
//                       style: kSubtitle1,
//                     ),
//                     SizedBox(width: 2),
//                     Icon(Icons.favorite_border, color: Theme.of(context).accentColor),
//                   ],
//                 )),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               // whether to include footer details or not (used for similar movies list)
//               height: withFooter ? constraints.maxHeight * 0.7 : constraints.maxHeight,
//               child: _buildBackgroundImage(context, constraints),
//             ),
//             if (withFooter)
//               Container(                
//                 height: constraints.maxHeight * 0.3,
//                 padding: const EdgeInsets.only(top: 10, left: 10),
//                 child: _buildFooter(context),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:e_movies/pages/details_page.dart';
// // import 'package:e_movies/widgets/placeholder_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_spinkit/flutter_spinkit.dart';
// // import 'package:intl/intl.dart' as intl;

// // import 'package:e_movies/consts/consts.dart';
// // import 'package:transparent_image/transparent_image.dart';
// // import '../pages/details_page.dart';

// // class MovieItem extends StatelessWidget {
// //   final movie;
// //   final bool withoutFooter;

// //   MovieItem({
// //     this.movie,
// //     this.withoutFooter = false,
// //   });

// //   Route _buildRoute(int id) {
// //     return PageRouteBuilder(
// //       settings: RouteSettings(arguments: movie),
// //       pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(),
// //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //         var begin = const Offset(
// //             1, 0); // if x > 0 and y = 0 transition is from right to left
// //         var end =
// //             Offset.zero; // if y > 0 and x = 0 transition is from bottom to top
// //         // var curve = Curves.bounceIn;
// //         var tween =
// //             Tween(begin: begin, end: end); // .chain(CurveTween(curve: curve))
// //         var offsetAnimation = animation.drive(tween);

// //         return SlideTransition(
// //           position: offsetAnimation,
// //           child: child,
// //         );
// //       },
// //     );
// //   }

// //   String getGenreName(int genreId) {
// //     if (GENRES.containsKey(genreId)) {
// //       return GENRES[genreId];
// //     }
// //     return 'N/A';
// //   }

// //   void _navigate(BuildContext context, int id) {
// //     Navigator.of(context).push(_buildRoute(id));
// //   }

// //   String _formatDate(DateTime date) {
// //     if (date == null) return 'N/A';
// //     else {
// //       return intl.DateFormat.yMMM().format(date);
// //     }
// //     // return date == null ? 'Unk' : ;
// //   }

// //   Widget _buildBackgroundImage(
// //       BuildContext context, String title, String imageUrl) {
// //     return imageUrl == null
// //         ? PlaceHolderImage(title)
// //         // ? Image.asset('assets/images/poster_placeholder.png', fit: BoxFit.cover)
// //         : CachedNetworkImage(
// //             imageUrl: imageUrl,
// //             fit: BoxFit.cover,
// //             placeholder: (context, url) {
// //               return Center(
// //                 child: SpinKitCircle(
// //                   color: Theme.of(context).accentColor,
// //                   size: LOADING_INDICATOR_SIZE,
// //                 ),
// //               );
// //             },
// //           );
// //   }

// //   Widget _buildFooter(BuildContext context, double screenWidth, String title,
// //       int genreId, dynamic date) {
// //     return Positioned.directional(
// //       width: screenWidth / 2,
// //       height: 65,
// //       bottom: 0,
// //       textDirection: TextDirection.ltr,
// //       child: Container(
// //         width: double.infinity,
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //               begin: Alignment.bottomCenter,
// //               end: Alignment.topCenter,
// //               colors: [
// //                 // Theme.of(context).accentColor.withOpacity(0.4),
// //                 // Theme.of(context).accentColor.withOpacity(0.9),
// //                 Color.fromRGBO(0, 0, 0, 1),
// //                 Color.fromRGBO(0, 0, 0, 0.2),
// //               ]),
// //           // backgroundBlendMode: BlendMode.colorBurn,
// //         ),
// //         constraints: BoxConstraints(maxWidth: screenWidth / 2 - 20),
// //         child: Padding(
// //           padding: const EdgeInsets.only(top: 8.0, left: 8),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title == null ? 'Unk' : title,
// //                 style: Theme.of(context).textTheme.headline5,
// //                 softWrap: false,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: 5),
// //               // FittedBox(
// //               //   child: Text(
// //               //     getGenreName(genreId),
// //               //     style: Theme.of(context).textTheme.subtitle1,
// //               //     softWrap: false,
// //               //     overflow: TextOverflow.ellipsis,
// //               //   ),
// //               // ),
// //               // SizedBox(height: 5),
// //               FittedBox(
// //                 child: Text(
// //                   _formatDate(date),
// //                   style: Theme.of(context).textTheme.subtitle1,
// //                   softWrap: false,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //               ),
// //               SizedBox(height: 10,),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;

// //     return GestureDetector(

// //       onTap: () => _navigate(context, movie.id),
// //       child: GridTile(
// //         child: Stack(
// //           children: <Widget>[
// //             _buildBackgroundImage(context, movie.title, movie.posterUrl),
// //             if (!withoutFooter)
// //               _buildFooter(
// //                 context,
// //                 screenWidth,
// //                 movie.title,
// //                 movie.genreIDs.isNotEmpty ? movie.genreIDs[0] : -1,
// //                 movie.releaseDate,
// //               )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
