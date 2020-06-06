import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:e_movies/providers/cast.dart' as prov;

class CastDetails extends StatefulWidget {
  static const routeName = '/cast-details';

  @override
  _CastDetailsState createState() => _CastDetailsState();
}

class _CastDetailsState extends State<CastDetails>
    with SingleTickerProviderStateMixin {
  bool _isInitLoaded = true;
  bool _isFetching = true;
  TabController _tabController;
  int _selectedIndex;

  @override
  void initState() {    
    super.initState();
    _selectedIndex = 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInitLoaded) {
      final item = ModalRoute.of(context).settings.arguments as dynamic;
      final id = item['id'];
      Provider.of<prov.Cast>(context, listen: false)
          .getPersonDetails(id)
          .then((value) {
        setState(() {
          _isFetching = false;
          _isInitLoaded = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Widget _buildTabBar() {
    return NavBar(
      tabController: _tabController,
      tabs: [
        Tab(
            child: Align(
          alignment: Alignment.center,
          child: Text(
            'Biography',
            style: kTitleStyle2,
          ),
        )),
        Tab(
            child: Align(
          alignment: Alignment.center,
          child: Text(
            'Movies',
            style: kTitleStyle2,
          ),
        )),
        // Tab(icon: Icon(Icons.edit)),
      ],
    );
  }

  Widget _buildTabs(prov.Person item) {
    return TabBarView(
      controller: _tabController,
      children: [
        Biography(item.biography),
        Movies(item.movies),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final item = ModalRoute.of(context).settings.arguments as dynamic;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    prov.Person person;
    if (!_isFetching) person = Provider.of<prov.Cast>(context).person;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ONE_LEVEL_ELEVATION,
          centerTitle: true,
          title: Text(item['name'], style: kTitleStyle),
        ),
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  padding: EdgeInsets.only(top: mediaQueryHeight * 0.4),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // _buildTabBar(),
                    Container(
                      color: ONE_LEVEL_ELEVATION,
                      width: constraints.maxWidth,
                      child: _buildTabBar(),
                    ),
                    Container(
                      height: constraints.maxHeight,
                      child: _isFetching
                          ? SpinKitCircle(
                              size: 21,
                              color: Theme.of(context).accentColor,
                            )
                          : _buildTabs(person),
                    ),
                  ],
                );
              },
            ),
            Container(
              width: double.infinity,
              height: mediaQueryHeight * 0.4,
              child: CachedNetworkImage(
                imageUrl: IMAGE_URL + item['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Biography extends StatelessWidget {
  final String biography;
  Biography(this.biography);
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).size.height * 0.4 + 2 * kToolbarHeight),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: LEFT_PADDING, vertical: 10),
          child: Text(
            biography,
            style: TextStyle(
              fontSize: 16,
              height: 2,
              color: Colors.white70,
            ),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class Movies extends StatelessWidget {
  final List<MovieItem> movies;
  Movies(this.movies);

  Route _buildRoute(MovieItem item) {
    final initData = {
      'id': item.id,
      'title': item.title,
      'genre': (item.genreIDs.length == 0 || item.genreIDs[0] == null)
          ? 'N/A'
          : item.genreIDs[0],
      'posterUrl': item.posterUrl,
      'backdropUrl': item.backdropUrl,
      'mediaType': 'movie',
      'releaseDate': item.date.year.toString() ?? 'N/A',
      'voteAverage': item.voteAverage,
    };
    return PageRouteBuilder(
      settings: RouteSettings(
        arguments: initData,
      ),
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

  void _onTap(BuildContext context, MovieItem item) {
    Navigator.of(context).push(_buildRoute(item));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      // separatorBuilder: (context, index) {
      //   return Padding(
      //     padding: EdgeInsets.only(left: 75),
      //     child: Divider(
      //       color: Colors.white,
      //       thickness: 0.2,
      //     ),
      //   );
      // },
      physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.4 + kToolbarHeight),
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () => _onTap(context, movies[i]),
          splashColor: Colors.transparent,
          highlightColor: Colors.black,
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            leading: Container(
              width: 70,
              margin: const EdgeInsets.only(left: LEFT_PADDING),
              color: BASELINE_COLOR,
              child: movies[i].posterUrl == null
                  ? PlaceHolderImage(movies[i].title)
                  : CachedNetworkImage(
                      imageUrl: movies[i].posterUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              movies[i].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: kBodyStyle,
            ),
            subtitle: RichText(
              text: TextSpan(text: 'as ', style: kSubtitle2, children: [
                TextSpan(
                    text: movies[i].character,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ))
              ]),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: LEFT_PADDING),
              child: Text(
                movies[i].date == null
                    ? 'N/A'
                    : DateFormat.y().format(movies[i].date),
                style: kSubtitle1,
              ),
            ),
          ),
        );
      },
    );
  }
}
