import 'package:e_movies/pages/in_theaters_page.dart';
import 'package:e_movies/pages/top_rated_page.dart';
import 'package:e_movies/providers/movies_provider.dart';
import 'package:e_movies/widgets/genre_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/widgets/movie_item.dart' as movieWid;

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _initLoaded = true;
  bool _isFetching = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<MoviesProvider>(context).fetchTopRated(1);
      Provider.of<MoviesProvider>(context, listen: false)
          .fetchInTheaters(1)
          .then((value) {
        setState(() {
          _isFetching = false;
          _initLoaded = false;
        });
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget _buildSectionTitle(String title, Function onTap, [bool withSeeAll = true]) {
    return Padding(
      padding: const EdgeInsets.only(
        left: LEFT_PADDING,
        right: LEFT_PADDING,
        top: 30,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kTitleStyle),
          if(withSeeAll)
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text('See All', style: kSeeAll)),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Hexcolor('#DEDEDE'),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _buildRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
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

  Widget _buildGenres() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),      
      key: PageStorageKey('GenresPageGrid'),
      physics: BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemCount: GENRE_DETAILS.length,
      itemBuilder: (context, i) {
        return GenreTile(
          imageUrl: GENRE_DETAILS[i]['imageUrl'],
          genreId: GENRE_DETAILS[i]['genreId'],
          title: GENRE_DETAILS[i]['title'],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2/3,
        // mainAxisSpacing: 10,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final inTheater = Provider.of<MoviesProvider>(context).inTheaters;
    final topRated = Provider.of<MoviesProvider>(context).topRated;
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: kToolbarHeight),
              child: Column(
                children: [
                  _buildSectionTitle('Genres', null, false),
                  Container(
                    // color: Colors.red                    
                    height: constraints.maxHeight * 0.25,
                    child: _buildGenres(),
                  ),                  
                  _buildSectionTitle('In Theaters', () {
                    Navigator.of(context).push(_buildRoute(InTheaters()));
                  }),
                  Container(
                      height: constraints.maxHeight * 0.5,
                      child: _isFetching
                          ? SpinKitCircle(
                              color: Theme.of(context).accentColor,
                              size: 21,
                            )
                          : Grid(movies: inTheater)),
                  _buildSectionTitle('Top Rated', () {
                    Navigator.of(context).push(_buildRoute(TopRated()));
                  }),
                  Container(
                      height: constraints.maxHeight * 0.5,
                      child: _isFetching
                          ? SpinKitCircle(
                              color: Theme.of(context).accentColor,
                              size: 21,
                            )
                          : Grid(movies: topRated)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class Grid extends StatelessWidget {
  final movies;
  Grid({this.movies});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey('Grid'),
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING),
      itemCount: movies.length > 20 ? 20 : movies.length,
      itemBuilder: (context, index) {
        return movieWid.MovieItem(
          movie: movies[index],
          withFooter: true,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2,
        // mainAxisSpacing: 5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }
}

// import 'package:e_movies/pages/genres_page.dart';
// import 'package:e_movies/pages/in_theaters_page.dart';
// import 'package:e_movies/pages/top_rated_page.dart';
// import 'package:e_movies/widgets/nav_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class MoviesScreen extends StatefulWidget {
//   @override
//   _MoviesScreenState createState() => _MoviesScreenState();
// }

// class _MoviesScreenState extends State<MoviesScreen>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final navBar = Align(
//       alignment: Alignment.topCenter,
//       child: NavBar(
//         // onTap: _onTap,
//         tabController: _tabController,
//         tabs: [
//           Tab(
//               child:
//                   Text('Genres', style: Theme.of(context).textTheme.headline5)),
//           Tab(
//               child: Text('In Theaters',
//                   style: Theme.of(context).textTheme.headline5)),
//           Tab(
//               child: Text('Top Rated',
//                   style: Theme.of(context).textTheme.headline5)),
//         ],
//       ),
//     );

//     final content = TabBarView(
//       controller: _tabController,
//       children: [
//         GenresPage(),
//         InTheaters(),
//         TopRated(),
//       ],
//     );

//     return SafeArea(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           content,
//           navBar,
//         ],
//       ),
//     );
//   }
// }
