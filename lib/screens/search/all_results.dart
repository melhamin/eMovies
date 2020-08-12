import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/models/actor_model.dart';
import 'package:e_movies/models/init_data.dart';
import 'package:e_movies/models/movie_model.dart';
import 'package:e_movies/screens/movie/movie_details/movie_details_screen.dart';
import 'package:e_movies/screens/tv/tv_details_screen.dart';
import 'package:e_movies/screens/search/searched_movie_item.dart';
import 'package:e_movies/screens/search/searched_tv_item.dart';
import 'package:e_movies/widgets/loading_indicator.dart';
import 'package:e_movies/widgets/movie/cast_item.dart';
import 'package:e_movies/providers/search.dart';
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_movies/screens/my_lists_screen.dart';

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

  Route _buildRoute(InitData initData, [bool searchHistoryItem = false]) {
    return MaterialPageRoute(
      builder: (context) => initData.mediaType == MediaType.Movie
              ? MovieDetailsScreen()
              : TVDetailsScreen(),
      settings: RouteSettings(arguments: initData)
    );   
  }

  Widget _buildSearchHistoryItem(
      BuildContext context, InitData item, int index) {
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
          child: item.posterUrl == null
              ? PlaceHolderImage(item.title)
              : CachedNetworkImage(
                  imageUrl: item.posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          item.title ?? 'N/A',
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
            Text(item.voteAverage == null ? 'N/A' : item.voteAverage.toString(),
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
      key: PageStorageKey('All Results'),
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      physics: const  AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        if (searchHistory.length > 0)
          Padding(
            padding: const EdgeInsets.only(
                top: 15, left: DEFAULT_PADDING + 5, bottom: 15),
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
        left: DEFAULT_PADDING,
        right: DEFAULT_PADDING,
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

  Widget _buildActors(List<ActorModel> items) {
    return GridView.builder(
      // padding:  EdgeInsets.only(left: LEFT_PADDING, right: LEFT_PADDING),
      
      itemCount: items.length > 10 ? 10 : items.length,
      itemBuilder: (ctx, i) {
        return CastItem(
         items[i],
        );
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
        return (items[i] is MovieModel)
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
          : LoadingIndicator(),
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
          : ListView(
              padding: const EdgeInsets.only(top: 10, bottom: kToolbarHeight),
              
              children: [
                ...[
                  _buildSectionTitle('Actors', () => widget.handleTabChange(3)),
                  Container(
                    // color: Colors.red,
                    height: 110,
                    child: widget.isLoading
                        ? _buildLoadingIndicator(context)
                        : _buildActors(actors),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
                    child: Divider(color: kTextBorderColor, thickness: 0.5),
                  ),
                ],
                SizedBox(height: 20),

                 ...[
                  _buildSectionTitle('Movies', () => widget.handleTabChange(1)),
                  Container(
                    child: widget.isLoading
                        ? _buildLoadingIndicator(context)
                        : _buildCategory(movies),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
                    child: Divider(color: kTextBorderColor, thickness: 0.5),
                  ),
                ],

                SizedBox(height: 20),
                 ...[
                  _buildSectionTitle(
                      'TV shows', () => widget.handleTabChange(2)),
                  Container(
                    child: widget.isLoading
                        ? _buildLoadingIndicator(context)
                        : _buildCategory(tvShows),
                  ),
                ]
                // Divider(color: kTextBorderColor, thickness: 0.5),
              ],
            ),
    );
  }
}
