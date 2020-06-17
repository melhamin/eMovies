import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/movie_details_screen.dart' show MovieDetailsScreen;
import 'package:e_movies/widgets/nav_bar.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/providers/cast.dart';

class CastDetails extends StatefulWidget {
  static const routeName = '/cast-details';

  @override
  _CastDetailsState createState() => _CastDetailsState();
}

class _CastDetailsState extends State<CastDetails>
    with SingleTickerProviderStateMixin {
  bool _isInitLoaded = true;
  bool _isLoading = true;
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
      final id = item.id;
      Provider.of<Cast>(context, listen: false)
          .getPersonDetails(id)
          .then((value) {
        setState(() {
          _isLoading = false;
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
            child: Text('Biography', style: kTitleStyle2),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Movies', style: kTitleStyle2),
          ),
        ),
        // Tab(icon: Icon(Icons.edit)),
      ],
    );
  }

  Widget _buildTabs(PersonModel item) {
    return TabBarView(
      controller: _tabController,
      children: [
        Biography(item: item, isLoading: _isLoading),
        Movies(item: item, isLoading: _isLoading),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final item = ModalRoute.of(context).settings.arguments as dynamic;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    PersonModel person;
    if (!_isLoading) person = Provider.of<Cast>(context).person;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ONE_LEVEL_ELEVATION,
          centerTitle: true,
          title: Text(item.name, style: kTitleStyle),
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
                      child:
                          //  _isLoading
                          //     ? SpinKitCircle(
                          //         size: 21,
                          //         color: Theme.of(context).accentColor,
                          //       )
                          // : _
                          _buildTabs(person),
                    ),
                  ],
                );
              },
            ),
            Container(
              width: double.infinity,
              height: mediaQueryHeight * 0.4,
              child: CachedNetworkImage(
                imageUrl: IMAGE_URL + item.imageUrl,
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
  final PersonModel item;
  final bool isLoading;
  Biography({this.item, this.isLoading});

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: SpinKitCircle(
          size: 21,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).size.height * 0.4 + 2 * kToolbarHeight),
        child: isLoading
            ? _buildLoadingIndicator(context)
            : Container(
                padding: EdgeInsets.symmetric(
                    horizontal: LEFT_PADDING, vertical: 10),
                child: Text(
                  item.biography,
                  style: TextStyle(
                    fontSize: 16,
                    height: 2,
                    color: Colors.white70,
                  ),
                  softWrap: true,
                ),
              ));
  }
}

class Movies extends StatelessWidget {
  final PersonModel item;
  final bool isLoading;
  Movies({this.item, this.isLoading});

  Route _buildRoute(MovieModel item) {
    final initData = InitData.formObject(item);
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

  void _onTap(BuildContext context, MovieModel item) {
    Navigator.of(context).push(_buildRoute(item));
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: SpinKitCircle(
          size: 21,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final movies = item.movies;
    return isLoading
        ? _buildLoadingIndicator(context)
        : ListView.builder(
            itemCount: item.movies.length,
            physics: const BouncingScrollPhysics(
                parent: const AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).size.height * 0.4 + kToolbarHeight),
            itemBuilder: (context, i) {
              final temp = item.movies[i];
              return InkWell(
                onTap: () => _onTap(context, temp),
                splashColor: Colors.transparent,
                highlightColor: Colors.black,
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Container(
                    width: 70,
                    margin: const EdgeInsets.only(left: LEFT_PADDING),
                    color: BASELINE_COLOR,
                    child: temp.posterUrl == null
                        ? PlaceHolderImage(temp.title)
                        : CachedNetworkImage(
                            imageUrl: temp.posterUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    temp.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kBodyStyle,
                  ),
                  subtitle: RichText(
                    text: TextSpan(text: 'as ', style: kSubtitle2, children: [
                      TextSpan(
                          text: temp.character,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ))
                    ]),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: LEFT_PADDING),
                    child: Text(
                      temp.date == null
                          ? 'N/A'
                          : DateFormat.y().format(temp.date),
                      style: kSubtitle1,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
