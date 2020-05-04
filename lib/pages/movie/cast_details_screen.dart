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

  prov.Person person;

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
          person =
              Provider.of<prov.Cast>(context, listen: false).person;
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
    print('item -------> ${item.id}');
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
                      color: BASELINE_COLOR,
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
    return Container(
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
    );
  }
}

class Movies extends StatelessWidget {
  final List<MovieItem> movies;
  Movies(this.movies);

  Route _buildRoute(int id) {
    return PageRouteBuilder(
      settings: RouteSettings(
        arguments: id,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(),
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

  void _onTap(BuildContext context, int id) {
    Navigator.of(context).push(_buildRoute(id));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: movies.length,
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 75),
          child: Divider(
            color: Colors.white,
            thickness: 0.2,
          ),
        );
      },
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Padding(
          padding:
              const EdgeInsets.only(left: LEFT_PADDING, right: LEFT_PADDING),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.comfortable,
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              child: movies[i].posterUrl == null
                  ? PlaceHolderImage(movies[i].title)
                  : CachedNetworkImage(
                      imageUrl: movies[i].posterUrl,
                    ),
            ),
            title: Text(
              movies[i].title,
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
            trailing: Text(
              movies[i].releaseDate == null
                  ? 'N/A'
                  : DateFormat.y().format(movies[i].releaseDate),
              style: Theme.of(context).textTheme.subtitle2,
            ),
            onTap: () => _onTap(context, movies[i].id),
          ),
        );
      },
    );
  }
}
