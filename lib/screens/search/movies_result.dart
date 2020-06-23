import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/screens/movie/movie_details_screen.dart';
import 'package:e_movies/providers/search.dart' show Search;
import 'package:e_movies/widgets/placeholder_image.dart';
import 'package:e_movies/screens/search/searched_movie_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

enum LoaderStatus {
  STABLE,
  LOADING,
}

class MoviesResult extends StatefulWidget {
  final bool isLoading;
  final TextEditingController searchController;
  MoviesResult({this.searchController, this.isLoading});

  @override
  _MoviesResultState createState() => _MoviesResultState();
}

class _MoviesResultState extends State<MoviesResult> {
  int curPage = 1;
  CancelableOperation _operation;
  LoaderStatus _loaderStatus = LoaderStatus.STABLE;
  bool _isFetchingNewData = false;

  @override
  void didChangeDependencies() {
    // clear searched movies list if use not searhing
    // if (widget.searchController.text.isEmpty)
    //   Provider.of<Search>(context, listen: false).clearMovies();
    super.didChangeDependencies();
  }

  // Widget _buildMovieSearchItem(BuildContext context, prov.MovieItem item) {
  //   return
  // }

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

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (_loaderStatus != null && _loaderStatus == LoaderStatus.STABLE) {
          _loaderStatus = LoaderStatus.LOADING;
          setState(() {
            _isFetchingNewData = true;
          });
          _operation = CancelableOperation.fromFuture(
                  Provider.of<Search>(context, listen: false)
                      .searchMovies(widget.searchController.text, curPage + 1))
              .then(
            (_) {
              _loaderStatus = LoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetchingNewData = false;
              });
            },
          );
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<Search>(context).movies;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // show recent search history when not searching
      child: widget.searchController.text.isEmpty
          ? Center(child: Text('Search movies', style: kTitleStyle))
          : widget.isLoading // Show loading indicator when fetching data
              ? _buildLoadingIndicator(context)
              : NotificationListener(
                  onNotification: onNotification,
                  child: ListView.builder(
                    key: PageStorageKey('MoviesResult'),
                    // controller: _scrollController,
                    padding: const EdgeInsets.only(
                        bottom: kToolbarHeight, left: 10, right: 10, top: 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: movies.length,
                    itemBuilder: (ctx, i) {
                      var item = movies[i];
                      return SearchedMovieItem(item);
                    },
                  ),
                ),
    );
  }
}
