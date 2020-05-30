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
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  void didChangeDependencies() {
    if (_isInitLoaded) {
      final item = ModalRoute.of(context).settings.arguments as prov.CastItem;
      final id = item.id;
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
            icon: Text(
          'Biography',
          style: kTitleStyle2,
        )),
        Tab(
            icon: Text(
          'Movies',
          style: kTitleStyle2,
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
    final item = ModalRoute.of(context).settings.arguments as prov.CastItem;
    prov.Person person;
    if (!_isFetching) person = Provider.of<prov.Cast>(context).person;
    // print('item -------> ${item.id}');
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  padding: EdgeInsets.only(top: APP_BAR_HEIGHT),
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: IMAGE_URL + item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // _buildTabBar(),
                    Container(
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
            TopBar(title: item.name),
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
      physics: const BouncingScrollPhysics(),
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
    return PageRouteBuilder(
      settings: RouteSettings(
        arguments: item,
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
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).size.height * 0.4 + 2 * kToolbarHeight),
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
                movies[i].releaseDate == null
                    ? 'N/A'
                    : DateFormat.y().format(movies[i].releaseDate),
                style: kSubtitle1,
              ),
            ),
          ),
        );
      },
    );
  }
}
