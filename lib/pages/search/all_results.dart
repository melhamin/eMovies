import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/pages/movie/movie_details_screen.dart';
import 'package:e_movies/pages/search/searched_movie_item.dart';
import 'package:e_movies/pages/search/searched_tv_item.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:e_movies/providers/movies.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllResults extends StatefulWidget {
  final TextEditingController searchController;
  final bool isLoading;
  final ValueChanged<int> handleTabChange;  

  AllResults({this.searchController, this.isLoading, this.handleTabChange});
  @override
  _AllResultsState createState() => _AllResultsState();
}

class _AllResultsState extends State<AllResults> {
  @override
  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    if (widget.searchController.text.isEmpty) {
      Provider.of<Search>(context, listen: false).clearMovies();
      Provider.of<Search>(context, listen: false).clearSeries();
      Provider.of<Search>(context, listen: false).clearPeople();
    }
    super.didChangeDependencies();
  }

  Route _buildRoute(dynamic item, [bool searchHistoryItem = false]) {
    Map<String, dynamic> initData = searchHistoryItem
        ? item
        : {
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
      settings: RouteSettings(arguments: initData),
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailsScreen(),
      // {
      //   // if()  MovieDetailsScreen(),

      // },
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

  Widget _buildSearchHistoryItem(
      BuildContext context, dynamic item, int index) {
    return InkWell(
      highlightColor: Colors.black,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(_buildRoute(item, true));
      },
      child: ListTile(
        // contentPadding: EdgeInsets.all(0),
        isThreeLine: false,
        leading: Container(
          height: 65,
          width: 50,
          child: item['posterUrl'] == null
              ? PlaceHolderImage(item['title'])
              : CachedNetworkImage(
                  imageUrl: item['posterUrl'],
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item['title'] ?? 'N/A',
          style: TextStyle(
            fontFamily: 'Helvatica',
            fontSize: 18,
            color: Colors.white.withOpacity(0.87),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: <Widget>[
            Text(
                item['voteAverage'] == null
                    ? 'N/A'
                    : item['voteAverage'].toString(),
                style: kSubtitle1),
            SizedBox(width: 5),
            Icon(Icons.favorite_border, color: Theme.of(context).accentColor)
          ],
        ),
        trailing: IconButton(
          splashColor: Colors.transparent,
          icon: Icon(
            Icons.close,
            color: Colors.white.withOpacity(0.45),
          ),
          onPressed: () {
            Provider.of<Search>(context, listen: false)
                .removeSearchHistoryItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    final searchHistory = Provider.of<Search>(context).searchHistory;
    return ListView(
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics()),
      children: <Widget>[
        if (searchHistory.length > 0)
          Padding(
            padding: const EdgeInsets.only(
                top: 15, left: LEFT_PADDING + 5, bottom: 15),
            child: Text('Recent searches', style: kTitleStyle2),
          ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: searchHistory.length,
          itemBuilder: (ctx, i) {
            return _buildSearchHistoryItem(context, searchHistory[i], i);
          },
        ),
        if (searchHistory.length > 0)
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
              child: OutlineButton(
                focusColor: Theme.of(context).accentColor,
                // highlightColor: Theme.of(context).accentColor,
                highlightedBorderColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.6), width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('Clear All', style: kBodyStyle),
                onPressed: () {
                  Provider.of<Search>(context, listen: false)
                      .clearSearchHistory();
                },
              ),
            ),
          )
      ],
    );
  }

  String _getName(String str) {
    if (str == null || str.length == 0) return 'N/A';

    String res = '';
    List<String> name = str.split(' ');
    if (name.length >= 2)
      res = res + name[0][0].toUpperCase() + name[1][0].toUpperCase();
    else if (name.length == 1)
      res = res + name[0][0].toUpperCase();
    else
      res = 'N/A';

    return res;
  }

  Widget _buildSectionTitle(String title, Function onTap,
      [bool withSeeAll = true]) {
    return Padding(
      padding: const EdgeInsets.only(
        left: LEFT_PADDING,
        right: LEFT_PADDING,
        // top: 30,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kSubtitle1),
          if (withSeeAll)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text('See All',
                          style: TextStyle(
                              fontFamily: 'Helvatica',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.45)))),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 14,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActors(List<ActorItem> items) {
    return GridView.builder(
      // padding:  EdgeInsets.only(left: LEFT_PADDING, right: LEFT_PADDING),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length > 10 ? 10 : items.length,
      itemBuilder: (ctx, i) {
        return CastItem(
          id: items[i].id,
          name: items[i].name,
          imageUrl: items[i].imageUrl,
        );
        // Column(
        //   children: [
        //     InkWell(
        //       splashColor: Colors.transparent,
        //       highlightColor: Colors.black,
        //       onTap: () => null,
        //       child: Card(
        //         elevation: 4,
        //         shadowColor: Colors.white24,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(40)),
        //         child: CircleAvatar(
        //           radius: 35,
        //           backgroundColor: items[i].imageUrl == null
        //               ? Theme.of(context).accentColor
        //               : Colors.black,
        //           backgroundImage: items[i].imageUrl != null
        //               ? NetworkImage(IMAGE_URL + items[i].imageUrl)
        //               : null,
        //           child: items[i].imageUrl != null
        //               ? null
        //               : Text(
        //                   _getName(items[i].name),
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: 5),
        //     Text(items[i].name,
        //         style: TextStyle(
        //           fontFamily: 'Helvatica',
        //           // fontWeight: FontWeight.bold,
        //           fontSize: 14,
        //           color: Hexcolor('#FFFFFF').withOpacity(0.87),
        //         ),
        //         overflow: TextOverflow.ellipsis,
        //         maxLines: 1),
        //   ],
        // );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        // mainAxisSpacing: 5,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _buildCategory(List<dynamic> items) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length > 15 ? 15 : items.length,
      itemBuilder: (ctx, i) {
        return (items[i] is MovieItem)
            ? SearchedMovieItem(
                items[i],
              )
            : SearchedTVItem(items[i]);
      },
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: widget.searchController.text.isEmpty
          ? null
          : SpinKitCircle(
              size: 21,
              color: Theme.of(context).accentColor,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actors = Provider.of<Search>(context).actors;
    final movies = Provider.of<Search>(context).movies;
    final tvShows = Provider.of<Search>(context).tvShows;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: widget.searchController.text.isEmpty
          ? _buildRecentSearches(context)
          : widget.isLoading
              ? _buildLoadingIndicator(context)
              : ListView(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: kToolbarHeight),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle('Actors', () => widget.handleTabChange(3)),
                    Container(
                      height: 110,
                      child: _buildActors(actors),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                      child: Divider(color: kTextBorderColor, thickness: 0.5),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Movies', () => widget.handleTabChange(1)),
                    _buildCategory(movies),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                      child: Divider(color: kTextBorderColor, thickness: 0.5),
                    ),

                    SizedBox(height: 20),
                    _buildSectionTitle('TV shows', () => widget.handleTabChange(2)),
                    _buildCategory(tvShows),
                    // Divider(color: kTextBorderColor, thickness: 0.5),
                  ],
                ),
    );
  }
}
