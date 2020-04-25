import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/details_page.dart';
import 'package:e_movies/providers/movies_provider.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/providers/cast_provider.dart' as prov;

class CastDetails extends StatefulWidget {
  static const routeName = '/cast-details';

  @override
  _CastDetailsState createState() => _CastDetailsState();
}

class _CastDetailsState extends State<CastDetails>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
      Provider.of<prov.CastProvider>(context, listen: false)
          .getPersonDetails(id)
          .then((value) {
        setState(() {
          _isFetching = false;
          _isInitLoaded = false;
          person =
              Provider.of<prov.CastProvider>(context, listen: false).person;
        });
      });
    }
    super.didChangeDependencies();
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
            icon: Text(
          'Biography',
          style: Theme.of(context).textTheme.headline3,
        )),
        Tab(
            icon: Text(
          'Movies',
          style: Theme.of(context).textTheme.headline3,
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
    super.build(context);
    final item = ModalRoute.of(context).settings.arguments as prov.CastItem;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  padding: EdgeInsets.only(top: 56),
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
            TopBar(item.name),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Biography extends StatelessWidget {
  final String biography;
  Biography(this.biography);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: PADDING, vertical: 10),
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
      pageBuilder: (context, animation, secondaryAnimation) => DetailsPage(),
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
          padding: const EdgeInsets.only(left: PADDING),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.comfortable,
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.amber,
              backgroundImage: movies[i].imageUrl != null
                  ? NetworkImage(
                      movies[i].imageUrl,
                    )
                  : null,
            ),
            title: Text(
              movies[i].title,
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: Text(
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
